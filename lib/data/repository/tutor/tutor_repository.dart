import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettutor/data/model/tutor/tutor.dart';

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
        onSuccess(tutors, null);
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
  }) async {
    try {
      Query query = _firestore
          .collection('tutors')
          .orderBy(FieldPath.documentId)
          .limit((pageIndex + 1) * pageSize);

      QuerySnapshot snapshot = await query.get();

      List<QueryDocumentSnapshot> docs = snapshot.docs;

      if (docs.isEmpty) {
        onSuccess([]);
        return;
      }

      final start = pageIndex * pageSize;
      final end = start + pageSize;
      final currentDocs = docs.sublist(
        start < docs.length ? start : docs.length,
        end < docs.length ? end : docs.length,
      );

      List<Tutor> tutors =
          currentDocs.map((doc) => Tutor.fromFirestore(doc)).toList();

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
}
