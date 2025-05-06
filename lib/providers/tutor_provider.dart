import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/model/tutor/tutor.dart';
import 'package:lettutor/data/model/user/learn_topic.dart';
import 'package:lettutor/data/repository/tutor/tutor_repository.dart';

class TutorProvider with ChangeNotifier {
  final TutorRepository _tutorRepository = TutorRepository();

  final List<Tutor> _tutors = [];
  List<Tutor> get tutors => _tutors;

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

  List<LearnTopic> _categories = [];
  List<LearnTopic> get categories => _categories;

  // Biến lưu lại lastDoc để phân trang
  DocumentSnapshot? _lastDoc;
  DocumentSnapshot? get lastDoc => _lastDoc;

  // Hàm cập nhật các bộ lọc
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

  // Hàm fetch dữ liệu giáo viên với phân trang
  Future<void> fetchTutorsByPage({
    required int pageIndex,
    required int pageSize,
    String? search,
    List<String>? specialities,
  }) async {
    try {
      // Reset lastDoc nếu bạn quay lại trang đầu (pageIndex == 0)
      if (pageIndex == 0) {
        _lastDoc = null; // Reset lastDoc để đảm bảo không sử dụng dữ liệu cũ
      }

      // Gọi phương thức phân trang của repository
      await _tutorRepository.getTutorListWithPagination(
        size: pageSize,
        page: pageIndex,
        orderBy: _orderBy,
        order: _order,
        level: _selectedLevel != null ? [_selectedLevel!] : null,
        search: search,
        categoryStr: specialities,
        lastDoc: _lastDoc,
        onSuccess: (List<Tutor> data, DocumentSnapshot? lastVisible) {
          if (pageIndex == 0) {
            _tutors.clear(); // Reset danh sách khi chuyển trang đầu
          }

          // Thêm dữ liệu mới vào danh sách tutors
          if (data.isNotEmpty) {
            _tutors.addAll(data);
            _lastDoc = lastVisible; // Cập nhật lastDoc

            // Nếu dữ liệu tải về đủ kích thước trang, có thể có dữ liệu tiếp theo
            _hasMoreData = data.length == pageSize;
          } else {
            // Nếu không có dữ liệu mới, đặt _hasMoreData thành false
            _hasMoreData = false;
          }

          currentPage = pageIndex;
          notifyListeners();
        },
        onFail: (String error) {
          _hasMoreData = false;
          debugPrint("Error fetching tutors: $error");
          notifyListeners();
        },
      );
    } catch (e) {
      _hasMoreData = false;
      debugPrint("Exception: $e");
      notifyListeners();
    }
  }

  // Hàm tính tổng số trang dựa trên kết quả lọc
  Future<void> fetchTotalPages({required int pageSize}) async {
    try {
      final total = await _tutorRepository.countFilteredTutors(
        search: _searchQuery,
        level: _selectedLevel != null ? [_selectedLevel!] : null,
        categoryStr: _selectedCategory != null ? [_selectedCategory!] : null,
      );
      _totalPages = (total / pageSize).ceil();
      notifyListeners();
    } catch (e) {
      _totalPages = 0;
      debugPrint("Error calculating total pages: $e");
      notifyListeners();
    }
  }

  // Hàm reset lại trạng thái, có thể giữ lại các bộ lọc hay không
  void resetState({bool resetFilters = false}) {
    _tutors.clear();
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

  // Hàm đặt trang hiện tại
  void setCurrentPage(int page) {
    currentPage = page;
    notifyListeners();
  }

  // Hàm lấy danh mục (categories)
  Future<void> fetchCategories() async {
    try {
      await _tutorRepository.getCategories(
        onSuccess: (List<LearnTopic> data) {
          _categories = data;
          notifyListeners();
        },
        onFail: (String error) {
          _categories = [];
          notifyListeners();
          debugPrint("Lỗi khi lấy categories: $error");
        },
      );
    } catch (e) {
      _categories = [];
      notifyListeners();
      debugPrint("Exception khi lấy categories: $e");
    }
  }

  void clearTutors() {
    tutors.clear();
    notifyListeners();
  }
}
