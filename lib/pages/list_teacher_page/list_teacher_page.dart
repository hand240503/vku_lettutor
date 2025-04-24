import 'package:flutter/material.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/common/drawer.dart';
import 'package:lettutor/pages/list_teacher_page/components/banner_component.dart';
import 'package:lettutor/pages/list_teacher_page/components/filter_component.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchTutors());
  }

  Future<void> _fetchTutors() async {
    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);

    if (!_hasFetched) {
      setState(() {
        _isLoadingPagination = true;
      });

      await tutorProvider.fetchTutors(limit: 1).whenComplete(() {
        if (!tutorProvider.hasMoreData) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Không thể lấy danh sách tutor hoặc đã hết dữ liệu',
              ),
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
  }

  // Hàm làm mới trang và tải lại dữ liệu
  Future<void> refreshHomePage() async {
    setState(() {
      _isLoadingPagination = true;
    });

    TutorProvider tutorProvider = context.read<TutorProvider>();
    AuthProvider authProvider = context.read<AuthProvider>();

    // Làm mới dữ liệu
    await Future.wait([tutorProvider.fetchTutors(limit: 5)]).whenComplete(() {
      if (mounted) {
        setState(() {
          _isLoadingPagination = false;
        });
      }
    });
  }

  void onSearch(
    String tutorName,
    List<String> specialities,
    Map<String, bool> nationalities,
  ) async {
    setState(() {
      _isLoadingPagination = true;
    });

    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);
    await tutorProvider.fetchTutors(limit: 1);
    await tutorProvider.fetchTotalPages(pageSize: 2);

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
              FilterComponent(onSearch: onSearch),
              Container(
                padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                child: const Divider(
                  height: 20,
                  color: Color.fromRGBO(238, 238, 238, 60),
                  thickness: 1,
                ),
              ),
              // !_isLoadingPagination
              //     ? ListTeacherComponent()
              //     : const Padding(
              //       padding: EdgeInsets.all(20),
              //       child: Center(child: CircularProgressIndicator()),
              //     ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: NumberPaginator(
                  numberPages: 10,
                  onPageChange: (int index) async {
                    setState(() {
                      _isLoadingPagination = true;
                    });

                    await tutorProvider
                        .fetchTutorsByPage(pageIndex: index + 1, pageSize: 2)
                        .whenComplete(() {
                          if (mounted) {
                            setState(() {
                              _isLoadingPagination = false;
                            });
                          }
                        });
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
