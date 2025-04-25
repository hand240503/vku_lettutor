import 'package:flutter/material.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/common/drawer.dart';
import 'package:lettutor/pages/list_teacher_page/components/banner_component.dart';
import 'package:lettutor/pages/list_teacher_page/components/filter_component.dart';
import 'package:lettutor/pages/list_teacher_page/components/listTeacher_component.dart';
import 'package:lettutor/providers/auth_provider.dart';
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
  bool _hasFetched = false;
  int _currentPage = 0;
  final int _pageSize = 2;
  String _tutorName = '';
  List<String> _specialities = [];
  Map<String, bool> _nationalities = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchTutors());
  }

  Future<void> _fetchTutors() async {
    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);

    setState(() {
      _isLoadingPagination = true;
    });

    // Lấy dữ liệu của trang đầu tiên
    await tutorProvider.fetchTutors(limit: _pageSize).whenComplete(() async {
      await tutorProvider.fetchTotalPages(pageSize: _pageSize);

      if (!tutorProvider.hasMoreData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể lấy danh sách tutor hoặc đã hết dữ liệu'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }

      if (mounted) {
        setState(() {
          _hasFetched = true;
          _isLoadingPagination = false;
        });
      }
    });
  }

  // Hàm làm mới trang và tải lại dữ liệu
  Future<void> refreshHomePage() async {
    setState(() {
      _isLoadingPagination = true;
    });

    TutorProvider tutorProvider = context.read<TutorProvider>();
    AuthProvider authProvider = context.read<AuthProvider>();

    // Làm mới dữ liệu
    await Future.wait([
      tutorProvider.fetchTutors(limit: _pageSize),
    ]).whenComplete(() {
      if (mounted) {
        setState(() {
          _isLoadingPagination = false;
        });
      }
    });
  }

  // Phương thức để lấy dữ liệu của trang cụ thể
  Future<void> _loadPageData(int pageIndex) async {
    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);
    setState(() {
      _isLoadingPagination = true;
      _currentPage = pageIndex;
    });

    // Lấy dữ liệu cho trang hiện tại
    await tutorProvider
        .fetchTutorsByPage(pageIndex: pageIndex, pageSize: _pageSize)
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _isLoadingPagination = false;
            });
          }
        });
  }

  // Hàm tìm kiếm
  void onSearch(
    String tutorName,
    List<String> specialities,
    Map<String, bool> nationalities,
  ) async {
    setState(() {
      _isLoadingPagination = true;
    });

    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);

    // Cập nhật lại các tham số tìm kiếm
    _tutorName = tutorName;
    _specialities = specialities;
    _nationalities = nationalities;

    // Tìm kiếm với các bộ lọc
    // await tutorProvider.fetchTutorsBySearch(
    //   tutorName: _tutorName,
    //   specialities: _specialities,
    //   nationalities: _nationalities,
    //   limit: _pageSize,
    // );

    if (mounted) {
      setState(() {
        _isLoadingPagination = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;

    final tutorProvider = Provider.of<TutorProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: refreshHomePage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              BannerComponent(myColor: myColor),
              FilterComponent(onSearch: onSearch), // Gửi tham số tìm kiếm
              Container(
                padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                child: const Divider(
                  height: 20,
                  color: Color.fromRGBO(238, 238, 238, 60),
                  thickness: 1,
                ),
              ),
              !_isLoadingPagination
                  ? ListTeacherComponent()
                  : const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  ),

              // Phân trang
              if (tutorProvider.totalPages > 0)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: NumberPaginator(
                    numberPages: tutorProvider.totalPages,
                    onPageChange: (int index) async {
                      await _loadPageData(
                        index,
                      ); // Load dữ liệu khi bấm phân trang
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
