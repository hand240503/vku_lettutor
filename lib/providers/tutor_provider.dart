import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/model/tutor/tutor.dart';
import 'package:lettutor/data/model/user/learn_topic.dart';
import 'package:lettutor/data/repository/tutor/tutor_repository.dart';

class TutorProvider with ChangeNotifier {
  final TutorRepository _tutorRepository = TutorRepository();

  final List<Tutor> _tutors = [];
  List<Tutor> get tutors => _tutors;

  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  int _totalPages = 0;
  int get totalPages => _totalPages;

  List<LearnTopic> _categories = [];
  List<LearnTopic> get categories => _categories;

  Future<void> fetchTutors({required int limit}) async {
    if (!_hasMoreData) return;

    try {
      await _tutorRepository.getTutors(
        onSuccess: (List<Tutor> newTutors, DocumentSnapshot? lastDoc) {
          if (newTutors.isEmpty) {
            _hasMoreData = false;
          } else {
            _tutors.addAll(newTutors);
            _lastDocument = lastDoc;
          }
          notifyListeners();
        },
        onFail: (String error) {
          _hasMoreData = false;
          notifyListeners();
        },
        limit: limit,
      );
    } catch (e) {
      _hasMoreData = false;
      notifyListeners();
    }
  }

  Future<void> fetchTutorById(String tutorId) async {
    try {
      await _tutorRepository.getTutorById(
        tutorId: tutorId,
        onSuccess: (Tutor tutor) {
          notifyListeners();
        },
        onFail: (String error) {
          notifyListeners();
        },
      );
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> fetchTutorsByPage({
    required int pageIndex,
    required int pageSize,
  }) async {
    try {
      await _tutorRepository.getTutorsByPage(
        pageIndex: pageIndex,
        pageSize: pageSize,
        onSuccess: (List<Tutor> data) {
          // Nếu trang không phải là trang đầu, chỉ cần thêm dữ liệu mới vào danh sách hiện tại.
          if (pageIndex > 0) {
            _tutors.addAll(data);
          } else {
            // Nếu là trang đầu, thay thế dữ liệu hiện tại bằng dữ liệu mới.
            _tutors
              ..clear()
              ..addAll(data);
          }
          notifyListeners();
        },
        onFail: (String error) {
          _tutors.clear();
          notifyListeners();
        },
        lastDocument:
            _lastDocument, // Truyền lastDocument vào để phân trang chính xác
      );
    } catch (e) {
      _tutors.clear();
      notifyListeners();
    }
  }

  Future<void> fetchTotalPages({required int pageSize}) async {
    await _tutorRepository.getTotalPages(
      pageSize: pageSize,
      onSuccess: (int pages) {
        _totalPages = pages;
        notifyListeners();
      },
      onFail: (_) {
        _totalPages = 0;
        notifyListeners();
      },
    );
  }

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
          print("Lỗi khi lấy categories: $error");
        },
      );
    } catch (e) {
      _categories = [];
      notifyListeners();
      print("Exception khi lấy categories: $e");
    }
  }
}
