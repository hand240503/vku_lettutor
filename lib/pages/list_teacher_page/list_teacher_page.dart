import 'package:flutter/material.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/common/drawer.dart';
import 'package:lettutor/pages/list_teacher_page/components/banner_component.dart';
import 'package:lettutor/pages/list_teacher_page/components/filter_component.dart';
import 'package:lettutor/pages/list_teacher_page/components/listTeacher_component.dart';
import 'package:lettutor/providers/tutor_provider.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

class ListTeacherPage extends StatefulWidget {
  const ListTeacherPage({super.key});

  @override
  State<ListTeacherPage> createState() => _ListTeacherPageState();
}

class _ListTeacherPageState extends State<ListTeacherPage> {
  late Color myColor;
  late Size mediaSize;

  bool _isLoadingPagination = false;
  final int _pageSize = 2;

  String? _currentSearch;
  List<String>? _currentSpecialities;

  @override
  void initState() {
    myColor = Colors.blue;
    super.initState();
    loadDataPage(0, null, null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tutorProvider = Provider.of<TutorProvider>(context, listen: false);
      tutorProvider.fetchTotalPages(pageSize: _pageSize);
      tutorProvider.fetchCategories();
    });
  }

  Future<void> loadDataPage(
    int page,
    String? search,
    List<String>? specialities,
  ) async {
    setState(() {
      _isLoadingPagination = true;
    });

    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);

    // Kiểm tra xem bộ lọc có thay đổi không
    bool filtersChanged = false;
    if (search != _currentSearch || specialities != _currentSpecialities) {
      filtersChanged = true;
    }

    if (filtersChanged) {
      tutorProvider.setCurrentPage(0);
      page = 0;
      _currentSearch = search;
      _currentSpecialities = specialities;
    }

    try {
      // Làm sạch dữ liệu cũ
      tutorProvider
          .clearTutors(); // Phương thức này xóa dữ liệu trong danh sách

      // Tải lại dữ liệu
      await tutorProvider.fetchTutorsByPage(
        pageIndex: page,
        pageSize: _pageSize,
        search: _currentSearch,
        specialities: _currentSpecialities,
      );

      // Cập nhật số trang
      await tutorProvider.fetchTotalPages(pageSize: _pageSize);
    } catch (error) {
      _showErrorMessage(error.toString());
    } finally {
      setState(() {
        _isLoadingPagination = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _refreshData() async {
    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);
    tutorProvider.resetState();
    await loadDataPage(0, _currentSearch, _currentSpecialities);
    await tutorProvider.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final tutorProvider = Provider.of<TutorProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CustomDrawer(),
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              const SizedBox(height: 16),
              BannerComponent(myColor: myColor),

              // FilterComponent với danh sách specialities
              FilterComponent(
                onSearch: (
                  String search,
                  List<String> specialities,
                  Map<String, bool> filters,
                ) {
                  loadDataPage(0, search, specialities);
                },
                specialities: tutorProvider.categories,
              ),

              const SizedBox(height: 12),
              const Divider(
                height: 20,
                color: Color.fromRGBO(238, 238, 238, 60),
                thickness: 1,
              ),

              !_isLoadingPagination
                  ? ListTeacherComponent()
                  : const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  ),

              if (tutorProvider.totalPages > 0)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: NumberPaginator(
                    numberPages: tutorProvider.totalPages,
                    onPageChange: (int index) async {
                      await loadDataPage(
                        index,
                        _currentSearch,
                        _currentSpecialities,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(TutorProvider tutorProvider) {
    if (_isLoadingPagination) {
      return const Center(child: CircularProgressIndicator());
    } else if (tutorProvider.tutors.isEmpty) {
      return Center(
        child: Text('No tutors found.', style: const TextStyle(fontSize: 16)),
      );
    } else {
      return ListTeacherComponent();
    }
  }

  Widget _buildPaginator(TutorProvider tutorProvider) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: NumberPaginator(
        numberPages:
            tutorProvider.totalPages > 0 ? tutorProvider.totalPages : 1,
        initialPage: tutorProvider.currentPage,
        onPageChange: (int index) async {
          await loadDataPage(index, _currentSearch, _currentSpecialities);
        },
      ),
    );
  }
}
