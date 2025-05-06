  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:lettutor/data/model/tutor/tutor.dart';
  import 'package:lettutor/data/model/user/learn_topic.dart';

  class TutorRepository {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> getTutorListWithPagination({
      required int size,
      required int page,
      String? orderBy,
      String? order,
      List<int>? level,
      String? search,
      List<String>? categoryStr,
      DocumentSnapshot? lastDoc, // Thêm tham số lastDoc
      required Function(List<Tutor> data, DocumentSnapshot? lastVisible)
      onSuccess,
      required Function(String error) onFail,
    }) async {
      try {
        Query query = FirebaseFirestore.instance
            .collection('tutors')
            .limit(size)
            .orderBy(orderBy ?? 'name', descending: order == 'desc');

        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc); // Tiếp tục từ lastDoc
        }

        // Thêm các bộ lọc khác nếu có
        if (level != null) {
          query = query.where('level', whereIn: level);
        }
        if (search != null) {
          query = query
              .where('name', isGreaterThanOrEqualTo: search)
              .where('name', isLessThanOrEqualTo: '$search\uf8ff');
        }
        if (categoryStr != null) {
          query = query.where('category', whereIn: categoryStr);
        }

        final snapshot = await query.get();

        if (snapshot.docs.isNotEmpty) {
          List<Tutor> tutors =
              snapshot.docs.map((doc) {
                return Tutor.fromFirestore(doc);
              }).toList();

          DocumentSnapshot? lastVisible =
              snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
          onSuccess(tutors, lastVisible);
        } else {
          onSuccess([], null);
        }
      } catch (e) {
        onFail("Error: $e");
      }
    }

    Future<int> countFilteredTutors({
      String? search,
      List<int>? level,
      List<String>? categoryStr,
    }) async {
      try {
        Query query = _firestore.collection('tutors');

        if (level != null && level.isNotEmpty) {
          final levelStrings = level.map((e) => (e + 1).toString()).toList();
          query = query.where('level', whereIn: levelStrings);
        }

        if (categoryStr != null && categoryStr.isNotEmpty) {
          final categoryRefs =
              categoryStr.map((id) {
                return _firestore.collection('categories').doc(id);
              }).toList();
          query = query.where('categories', arrayContainsAny: categoryRefs);
        }

        final snapshot = await query.get();
        List<Tutor> tutors =
            snapshot.docs.map((doc) => Tutor.fromFirestore(doc)).toList();

        if (search != null && search.isNotEmpty) {
          final lowerSearch = search.toLowerCase();
          tutors =
              tutors.where((tutor) {
                final name = tutor.name?.toLowerCase() ?? '';
                return name.contains(lowerSearch);
              }).toList();
        }

        return tutors.length;
      } catch (e) {
        print('Error counting tutors: $e');
        return 0;
      }
    }

    Future<void> getCategories({
      required Function(List<LearnTopic>) onSuccess,
      required Function(String error) onFail,
    }) async {
      try {
        final QuerySnapshot snapshot =
            await _firestore.collection('categories').get();

        List<LearnTopic> categories =
            snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return LearnTopic(
                id: doc.id.hashCode,
                key: data['key'] as String?,
                name: data['title'] as String?,
              );
            }).toList();

        onSuccess(categories);
      } catch (e) {
        onFail("Error retrieving categories: $e");
      }
    }
  }
