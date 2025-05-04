import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettutor/data/model/tutor/tutor.dart';
import 'package:lettutor/data/model/user/learn_topic.dart';

class TutorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getTutorById({
    required String tutorId,
    required Function(Tutor) onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('tutors').doc(tutorId).get();
      if (doc.exists) {
        onSuccess(Tutor.fromFirestore(doc));
      } else {
        onFail("Tutor with ID $tutorId not found.");
      }
    } catch (e) {
      onFail("Error retrieving tutor: $e");
    }
  }

  Future<void> getTutors({
    required Function(List<Tutor>, DocumentSnapshot?) onSuccess,
    required Function(String) onFail,
    required int limit,
  }) async {
    try {
      Query query = _firestore.collection('tutors').limit(limit);

      QuerySnapshot snapshot = await query.get();

      List<Tutor> tutors =
          snapshot.docs.map((doc) => Tutor.fromFirestore(doc)).toList();

      if (tutors.isEmpty) {
        onFail("No more tutors found.");
      } else {
        onSuccess(tutors, snapshot.docs.isEmpty ? null : snapshot.docs.last);
      }
    } catch (e) {
      onFail("Error retrieving tutors: $e");
    }
  }

  Future<void> getTutorsByPage({
    required int pageIndex,
    required int pageSize,
    required Function(List<Tutor>) onSuccess,
    required Function(String) onFail,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('tutors')
          .orderBy(FieldPath.documentId)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(
          lastDocument,
        ); // Start after the last document from the previous page
      }

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        onSuccess([]);
        return;
      }

      List<Tutor> tutors =
          snapshot.docs.map((doc) => Tutor.fromFirestore(doc)).toList();

      onSuccess(tutors);
    } catch (e) {
      onFail("Error retrieving tutors: $e");
    }
  }

  Future<void> getTotalPages({
    required int pageSize,
    required Function(int totalPages) onSuccess,
    required Function(String error) onFail,
  }) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('tutors').get();
      final int totalDocs = snapshot.docs.length;
      final int totalPages = (totalDocs / pageSize).ceil();
      onSuccess(totalPages);
    } catch (e) {
      onFail("Error counting tutors: $e");
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
