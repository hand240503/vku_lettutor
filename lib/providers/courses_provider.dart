import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/model/courses/course.dart';
import '../data/repository/courses/course_repository.dart';

class CoursesProvider extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();

  final List<Course> _courses = [];
  List<Course> get courses => _courses;

  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  int _totalPages = 0;
  int get totalPages => _totalPages;

  int perPage = 5;
  int currentPage = 1;

  // Hàm này lấy danh sách khóa học
  Future<void> fetchCourses({
    required String accessToken,
    required int limit,
    String? orderBy,
    String? order,
    String? search,
    int? level,
    String? categoryStr,
  }) async {
    if (!_hasMoreData) return;

    try {
      await _repository.getCourseListWithPagination(
        accessToken: accessToken,
        size: limit,
        page: 0,
        orderBy: orderBy,
        order: order,
        level: level,
        search: search,
        categoryStr: categoryStr,
        onSuccess: (List<Course> newCourses) {
          if (newCourses.isEmpty) {
            _hasMoreData = false;
          } else {
            _courses.addAll(newCourses);
          }
          notifyListeners();
        },
        onFail: (String error) {
          _hasMoreData = false;
          debugPrint("Error fetching courses: $error");
          notifyListeners();
        },
      );
    } catch (e) {
      _hasMoreData = false;
      debugPrint("Exception in fetchCourses: $e");
      notifyListeners();
    }
  }

  // Hàm này lấy danh sách sách điện tử
  Future<void> fetchEbooks({
    required String accessToken,
    required int limit,
    String? orderBy,
    String? order,
    String? search,
    int? level,
    String? categoryStr,
  }) async {
    if (!_hasMoreData) return;

    try {
      await _repository.getEbookListWithPagination(
        accessToken: accessToken,
        size: limit,
        page: 0,
        orderBy: orderBy,
        order: order,
        level: level,
        search: search,
        categoryStr: categoryStr,
        onSuccess: (List<Course> newEbooks) {
          if (newEbooks.isEmpty) {
            _hasMoreData = false;
          } else {
            _courses.addAll(newEbooks);
          }
          notifyListeners();
        },
        onFail: (String error) {
          _hasMoreData = false;
          debugPrint("Error fetching ebooks: $error");
          notifyListeners();
        },
      );
    } catch (e) {
      _hasMoreData = false;
      debugPrint("Exception in fetchEbooks: $e");
      notifyListeners();
    }
  }

  // Hàm này lấy danh sách sách điện tử tương tác
  Future<void> fetchInteractiveEbooks({
    required String accessToken,
    required int limit,
    String? orderBy,
    String? order,
    String? search,
    int? level,
    String? categoryStr,
  }) async {
    if (!_hasMoreData) return;

    try {
      await _repository.getInteractiveEbookListWithPagination(
        accessToken: accessToken,
        size: limit,
        page: 0,
        orderBy: orderBy,
        order: order,
        level: level,
        search: search,
        categoryStr: categoryStr,
        onSuccess: (List<Course> newInteractiveEbooks) {
          if (newInteractiveEbooks.isEmpty) {
            _hasMoreData = false;
          } else {
            _courses.addAll(newInteractiveEbooks);
          }
          notifyListeners();
        },
        onFail: (String error) {
          _hasMoreData = false;
          debugPrint("Error fetching interactive ebooks: $error");
          notifyListeners();
        },
      );
    } catch (e) {
      _hasMoreData = false;
      debugPrint("Exception in fetchInteractiveEbooks: $e");
      notifyListeners();
    }
  }

  // Hàm lấy khóa học theo trang
  Future<void> fetchCoursesByPage({
    required String accessToken,
    required int pageIndex,
    required int pageSize,
    String? orderBy,
    String? order,
    String? search,
    int? level,
    String? categoryStr,
  }) async {
    try {
      await _repository.getCourseListWithPagination(
        accessToken: accessToken,
        size: pageSize,
        page: pageIndex,
        orderBy: orderBy,
        order: order,
        level: level,
        search: search,
        categoryStr: categoryStr,
        onSuccess: (List<Course> data) {
          // Nếu trang không phải là trang đầu, chỉ cần thêm dữ liệu mới vào danh sách hiện tại
          if (pageIndex > 0) {
            _courses.addAll(data);
          } else {
            // Nếu là trang đầu, thay thế dữ liệu hiện tại bằng dữ liệu mới
            _courses
              ..clear()
              ..addAll(data);
          }
          currentPage = pageIndex;
          notifyListeners();
        },
        onFail: (String error) {
          debugPrint("Error fetching courses by page: $error");
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint("Exception in fetchCoursesByPage: $e");
      notifyListeners();
    }
  }

  // Hàm lấy sách điện tử theo trang
  Future<void> fetchEbooksByPage({
    required String accessToken,
    required int pageIndex,
    required int pageSize,
    String? orderBy,
    String? order,
    String? search,
    int? level,
    String? categoryStr,
  }) async {
    try {
      await _repository.getEbookListWithPagination(
        accessToken: accessToken,
        size: pageSize,
        page: pageIndex,
        orderBy: orderBy,
        order: order,
        level: level,
        search: search,
        categoryStr: categoryStr,
        onSuccess: (List<Course> data) {
          if (pageIndex > 0) {
            _courses.addAll(data);
          } else {
            _courses
              ..clear()
              ..addAll(data);
          }
          currentPage = pageIndex;
          notifyListeners();
        },
        onFail: (String error) {
          debugPrint("Error fetching ebooks by page: $error");
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint("Exception in fetchEbooksByPage: $e");
      notifyListeners();
    }
  }

  // Hàm lấy sách điện tử tương tác theo trang
  Future<void> fetchInteractiveEbooksByPage({
    required String accessToken,
    required int pageIndex,
    required int pageSize,
    String? orderBy,
    String? order,
    String? search,
    int? level,
    String? categoryStr,
  }) async {
    try {
      await _repository.getInteractiveEbookListWithPagination(
        accessToken: accessToken,
        size: pageSize,
        page: pageIndex,
        orderBy: orderBy,
        order: order,
        level: level,
        search: search,
        categoryStr: categoryStr,
        onSuccess: (List<Course> data) {
          if (pageIndex > 0) {
            _courses.addAll(data);
          } else {
            _courses
              ..clear()
              ..addAll(data);
          }
          currentPage = pageIndex;
          notifyListeners();
        },
        onFail: (String error) {
          debugPrint("Error fetching interactive ebooks by page: $error");
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint("Exception in fetchInteractiveEbooksByPage: $e");
      notifyListeners();
    }
  }

  // Hàm lấy tổng số trang
  Future<void> fetchTotalPages({required int pageSize}) async {
    // Có thể cần xây dựng một hàm tương tự trong repository để lấy tổng số trang
    // Hoặc sử dụng một truy vấn đếm tổng số tài liệu trong Firestore
    // Ví dụ:
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot snapshot = await firestore.collection('courses').get();
      final int totalDocs = snapshot.docs.length;
      _totalPages = (totalDocs / pageSize).ceil();
      notifyListeners();
    } catch (e) {
      _totalPages = 0;
      debugPrint("Error fetching total pages: $e");
      notifyListeners();
    }
  }

  // Reset lại trạng thái khi cần
  void resetState() {
    _courses.clear();
    _lastDocument = null;
    _hasMoreData = true;
    currentPage = 1;
    notifyListeners();
  }
}