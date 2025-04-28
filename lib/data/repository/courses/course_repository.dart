import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettutor/data/model/courses/course.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getCourseListWithPagination({
    required String accessToken,
    required int size,
    required int page,
    required String? orderBy,
    required String? order,
    required int? level,
    required String? search,
    required String? categoryStr,
    required Function(List<Course>) onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      Query query = _firestore.collection('courses')
          .limit(size);

      // Áp dụng các bộ lọc nếu được cung cấp
      if (level != null) {
        query = query.where('level', isEqualTo: level);
      }

      if (search != null && search.isNotEmpty) {
        query = query.where('name', isGreaterThanOrEqualTo: search)
            .where('name', isLessThanOrEqualTo: '$search\uf8ff');
      }

      if (categoryStr != null && categoryStr.isNotEmpty) {
        query = query.where('category', isEqualTo: categoryStr);
      }

      // Sắp xếp nếu có
      if (orderBy != null && order != null) {
        bool isDescending = order.toLowerCase() == 'desc';
        query = query.orderBy(orderBy, descending: isDescending);
      }

      // Phân trang
      if (page > 0) {
        // Lấy tài liệu cuối cùng của trang trước để thực hiện phân trang
        final prevPageQuery = query.limit(size * (page - 1));
        final prevPageDocs = await prevPageQuery.get();

        if (prevPageDocs.docs.isNotEmpty) {
          final lastDoc = prevPageDocs.docs.last;
          query = query.startAfterDocument(lastDoc);
        }
      }

      query = query.limit(size);

      QuerySnapshot snapshot = await query.get();

      List<Course> courses = snapshot.docs
          .map((doc) => Course.fromFirestore(doc))
          .toList();

      onSuccess(courses);
    } catch (e) {
      onFail("Error retrieving courses: $e");
    }
  }

  Future<void> getEbookListWithPagination({
    required String accessToken,
    required int size,
    required int page,
    required String? orderBy,
    required String? order,
    required int? level,
    required String? search,
    required String? categoryStr,
    required Function(List<Course>) onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      Query query = _firestore.collection('ebooks')
          .limit(size);

      // Áp dụng các bộ lọc nếu được cung cấp
      if (level != null) {
        query = query.where('level', isEqualTo: level);
      }

      if (search != null && search.isNotEmpty) {
        query = query.where('name', isGreaterThanOrEqualTo: search)
            .where('name', isLessThanOrEqualTo: '$search\uf8ff');
      }

      if (categoryStr != null && categoryStr.isNotEmpty) {
        query = query.where('category', isEqualTo: categoryStr);
      }

      // Sắp xếp nếu có
      if (orderBy != null && order != null) {
        bool isDescending = order.toLowerCase() == 'desc';
        query = query.orderBy(orderBy, descending: isDescending);
      }

      // Phân trang
      if (page > 0) {
        // Lấy tài liệu cuối cùng của trang trước để thực hiện phân trang
        final prevPageQuery = query.limit(size * (page - 1));
        final prevPageDocs = await prevPageQuery.get();

        if (prevPageDocs.docs.isNotEmpty) {
          final lastDoc = prevPageDocs.docs.last;
          query = query.startAfterDocument(lastDoc);
        }
      }

      query = query.limit(size);

      QuerySnapshot snapshot = await query.get();

      List<Course> ebooks = snapshot.docs
          .map((doc) => Course.fromFirestore(doc))
          .toList();

      onSuccess(ebooks);
    } catch (e) {
      onFail("Error retrieving ebooks: $e");
    }
  }

  Future<void> getInteractiveEbookListWithPagination({
    required String accessToken,
    required int size,
    required int page,
    required String? orderBy,
    required String? order,
    required int? level,
    required String? search,
    required String? categoryStr,
    required Function(List<Course>) onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      Query query = _firestore.collection('interactive_ebooks')
          .limit(size);

      // Áp dụng các bộ lọc nếu được cung cấp
      if (level != null) {
        query = query.where('level', isEqualTo: level);
      }

      if (search != null && search.isNotEmpty) {
        query = query.where('name', isGreaterThanOrEqualTo: search)
            .where('name', isLessThanOrEqualTo: '$search\uf8ff');
      }

      if (categoryStr != null && categoryStr.isNotEmpty) {
        query = query.where('category', isEqualTo: categoryStr);
      }

      // Sắp xếp nếu có
      if (orderBy != null && order != null) {
        bool isDescending = order.toLowerCase() == 'desc';
        query = query.orderBy(orderBy, descending: isDescending);
      }

      // Phân trang
      if (page > 0) {
        // Lấy tài liệu cuối cùng của trang trước để thực hiện phân trang
        final prevPageQuery = query.limit(size * (page - 1));
        final prevPageDocs = await prevPageQuery.get();

        if (prevPageDocs.docs.isNotEmpty) {
          final lastDoc = prevPageDocs.docs.last;
          query = query.startAfterDocument(lastDoc);
        }
      }

      query = query.limit(size);

      QuerySnapshot snapshot = await query.get();

      List<Course> interactiveEbooks = snapshot.docs
          .map((doc) => Course.fromFirestore(doc))
          .toList();

      onSuccess(interactiveEbooks);
    } catch (e) {
      onFail("Error retrieving interactive ebooks: $e");
    }
  }
}