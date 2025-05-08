import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lettutor/data/model/courses/course.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getCourseListWithPagination({
    required int size,
    required int page,
    required String? orderBy,
    required String? order,
    required List<int>? level,
    required String? search,
    required List<String>? categoryStr,
    required Function(List<Course>) onSuccess,
    required Function(String) onFail,
  }) async {
    await _getItemsWithPagination(
      collectionName: 'courses',
      size: size,
      page: page,
      orderBy: orderBy,
      order: order,
      level: level,
      search: search,
      categoryStr: categoryStr,
      onSuccess: onSuccess,
      onFail: onFail,
    );
  }

  Future<void> getEbookListWithPagination({
    required int size,
    required int page,
    required String? orderBy,
    required String? order,
    required List<int>? level,
    required String? search,
    required List<String>? categoryStr,
    required Function(List<Course>) onSuccess,
    required Function(String) onFail,
  }) async {
    await _getItemsWithPagination(
      collectionName: 'ebooks',
      size: size,
      page: page,
      orderBy: orderBy,
      order: order,
      level: level,
      search: search,
      categoryStr: categoryStr,
      onSuccess: onSuccess,
      onFail: onFail,
    );
  }

  Future<void> getInteractiveEbookListWithPagination({
    required int size,
    required int page,
    required String? orderBy,
    required String? order,
    required List<int>? level,
    required String? search,
    required List<String>? categoryStr,
    required Function(List<Course>) onSuccess,
    required Function(String) onFail,
  }) async {
    await _getItemsWithPagination(
      collectionName: 'interactive_ebooks',
      size: size,
      page: page,
      orderBy: orderBy,
      order: order,
      level: level,
      search: search,
      categoryStr: categoryStr,
      onSuccess: onSuccess,
      onFail: onFail,
    );
  }

  Future<void> _getItemsWithPagination({
    required String collectionName,
    required int size,
    required int page,
    required String? orderBy,
    required String? order,
    required List<int>? level,
    required String? search,
    required List<String>? categoryStr,
    required Function(List<Course>) onSuccess,
    required Function(String) onFail,
    bool useLegacyPagination = false,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;
      Query query = _firestore.collection(collectionName);

      // Filter by level
      if (level != null && level.isNotEmpty) {
        final levelStrings = level.map((e) => (e + 1).toString()).toList();
        query = query.where('level', whereIn: levelStrings);
      }

      // Filter by category
      if (categoryStr != null && categoryStr.isNotEmpty) {
        final categoryRefs = categoryStr.map((id) {
          return firestore.collection('categories').doc(id);
        }).toList();

        query = query.where('categories', arrayContainsAny: categoryRefs);
      }

      // Apply sorting
      if (orderBy != null && order != null) {
        final isDescending = order.toLowerCase() == 'desc';
        query = query.orderBy(orderBy, descending: isDescending);
      }

      // Apply pagination
      if (page > 0) {
        final prevPageSize = useLegacyPagination ? size * (page - 1) : size * page;
        final prevPageQuery = query.limit(prevPageSize);
        final prevPageDocs = await prevPageQuery.get();

        if (prevPageDocs.docs.isNotEmpty) {
          final lastDoc = prevPageDocs.docs.last;
          query = query.startAfterDocument(lastDoc);
        }
      }

      query = query.limit(size);
      final snapshot = await query.get();

      List<Course> items = await Future.wait(
        snapshot.docs.map((doc) => Course.fromFirestore(doc))
      );

      // Search
      if (search != null && search.isNotEmpty) {
        final lowerSearch = search.toLowerCase();
        items = items.where((course) {
          final name = course.name?.toLowerCase() ?? '';
          return name.contains(lowerSearch);
        }).toList();
      }

      onSuccess(items);
    } catch (e) {
      onFail("Error retrieving data from $collectionName: $e");
    }
  }

  Future<int> countFilteredCourses({
    required String collectionName,
    String? search,
    List<int>? level,
    List<String>? categoryStr,
  }) async {
    try {
      Query query = _firestore.collection(collectionName);

      // Filter by level
      if (level != null && level.isNotEmpty) {
        final levelStrings = level.map((e) => (e + 1).toString()).toList();
        query = query.where('level', whereIn: levelStrings);
      }

      // Filter by category
      if (categoryStr != null && categoryStr.isNotEmpty) {
        final categoryRefs = categoryStr.map((id) {
          return _firestore.collection('categories').doc(id);
        }).toList();

        query = query.where('categories', arrayContainsAny: categoryRefs);
      }

      final snapshot = await query.get();
      List<Course> items = await Future.wait(
        snapshot.docs.map((doc) => Course.fromFirestore(doc))
      );

      // Search
      if (search != null && search.isNotEmpty) {
        final lowerSearch = search.toLowerCase();
        items = items.where((course) {
          final name = course.name?.toLowerCase() ?? '';
          return name.contains(lowerSearch);
        }).toList();
      }

      return items.length;
    } catch (e) {
      debugPrint("Error counting documents in $collectionName: $e");
      return 0;
    }
  }
}