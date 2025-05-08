import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/model/courses/course.dart';
import '../data/model/courses/course_category.dart';
import '../data/repository/courses/course_repository.dart';

class CoursesProvider extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();

  final List<Course> _courses = [];
  List<Course> get courses => _courses;

  // Pagination tracking
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;
  int _totalPages = 0;
  int get totalPages => _totalPages;
  int perPage = 5;
  int currentPage = 1;

  String? _searchQuery;
  int? _selectedLevel;
  String? _selectedCategory;
  String? _orderBy;
  String? _order;

  String? get searchQuery => _searchQuery;
  int? get selectedLevel => _selectedLevel;
  String? get selectedCategory => _selectedCategory;
  String? get orderBy => _orderBy;
  String? get order => _order;

  void updateFilters({
    String? search,
    int? level,
    String? category,
    String? orderBy,
    String? order,
  }) {
    _searchQuery = search;
    _selectedLevel = level;
    _selectedCategory = category;
    _orderBy = orderBy;
    _order = order;
    notifyListeners();
  }

  Future<void> fetchCoursesByPage({
    required int pageIndex,
    required int pageSize,
    String? orderBy,
    String? order,
    String? search,
    List<int>? level,
    List<String>? categoryStr,
  }) async {
    await _fetchItemsByPage(
      fetchFunction: _repository.getCourseListWithPagination,
      pageIndex: pageIndex,
      pageSize: pageSize,
      orderBy: orderBy,
      order: order,
      search: search,
      level: level,
      categoryStr: categoryStr,
      clearBeforeAdd: true,
      errorMessage: "Error fetching courses by page",
      exceptionSource: "fetchCoursesByPage",
    );
  }

  Future<void> fetchEbooksByPage({
    required int pageIndex,
    required int pageSize,
    String? orderBy,
    String? order,
    String? search,
    List<int>? level,
    List<String>? categoryStr,
  }) async {
    await _fetchItemsByPage(
      fetchFunction: _repository.getEbookListWithPagination,
      pageIndex: pageIndex,
      pageSize: pageSize,
      orderBy: orderBy,
      order: order,
      search: search,
      level: level,
      categoryStr: categoryStr,
      clearBeforeAdd: true,
      errorMessage: "Error fetching ebooks by page",
      exceptionSource: "fetchEbooksByPage",
    );
  }

  Future<void> fetchInteractiveEbooksByPage({
    required int pageIndex,
    required int pageSize,
    String? orderBy,
    String? order,
    String? search,
    List<int>? level,
    List<String>? categoryStr,
  }) async {
    await _fetchItemsByPage(
      fetchFunction: _repository.getInteractiveEbookListWithPagination,
      pageIndex: pageIndex,
      pageSize: pageSize,
      orderBy: orderBy,
      order: order,
      search: search,
      level: level,
      categoryStr: categoryStr,
      clearBeforeAdd: true,
      errorMessage: "Error fetching interactive ebooks by page",
      exceptionSource: "fetchInteractiveEbooksByPage",
    );
  }

  Future<void> _fetchItemsByPage({
    required Future<void> Function({
      required int size,
      required int page,
      required String? orderBy,
      required String? order,
      required List<int>? level,
      required String? search,
      required List<String>? categoryStr,
      required Function(List<Course>) onSuccess,
      required Function(String) onFail,
    }) fetchFunction,
    required int pageIndex,
    required int pageSize,
    String? orderBy,
    String? order,
    String? search,
    List<int>? level,
    List<String>? categoryStr,
    required bool clearBeforeAdd,
    required String errorMessage,
    required String exceptionSource,
  }) async {
    try {
      await fetchFunction(
        size: pageSize,
        page: pageIndex,
        orderBy: orderBy,
        order: order,
        level: level,
        search: search,
        categoryStr: categoryStr,
        onSuccess: (List<Course> data) {
          if (clearBeforeAdd) {
            _courses.clear();
          }
          _courses.addAll(data);
          currentPage = pageIndex;
          _hasMoreData = data.isNotEmpty;
          notifyListeners();
        },
        onFail: (String error) {
          debugPrint("$errorMessage: $error");
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint("Exception in $exceptionSource: $e");
      notifyListeners();
    }
  }

  Future<void> fetchTotalPages({
    required int pageSize,
    required String collectionName,
    String? search,
    List<int>? level,
    List<String>? categoryStr,
  }) async {
    try {
      final totalDocs = await _repository.countFilteredCourses(
        collectionName: collectionName,
        search: search,
        level: level,
        categoryStr: categoryStr,
      );

      debugPrint("TOTAL DOCUMENTS: $totalDocs");
      _totalPages = (totalDocs / pageSize).ceil();
      notifyListeners();
    } catch (e) {
      _totalPages = 0;
      debugPrint("Error fetching total pages: $e");
      notifyListeners();
    }
  }

  void resetState({bool resetFilters = false}) {
    _courses.clear();
    _hasMoreData = true;
    currentPage = 1;

    if (resetFilters) {
      _searchQuery = null;
      _selectedLevel = null;
      _selectedCategory = null;
      _orderBy = null;
      _order = null;
    }

    notifyListeners();
  }

  void setCurrentPage(int page) {
    currentPage = page;
    notifyListeners();
  }

  Future<Map<String, String>> fetchCategories() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('categories').get();
      final Map<String, String> categoriesMap = {};

      for (var doc in snapshot.docs) {
        final courseCategory = CourseCategory.fromFirestore(doc);
        if (courseCategory.title != null && courseCategory.title!.isNotEmpty) {
          categoriesMap[doc.id] = courseCategory.title!;
        }
      }

      return categoriesMap;
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return {};
    }
  }
}