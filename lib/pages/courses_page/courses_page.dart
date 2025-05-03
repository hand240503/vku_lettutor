import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/common/drawer.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/courses_page/components/courses-main-info_component.dart';
import 'package:lettutor/pages/courses_page/components/list-courses_component.dart';

import '../../providers/auth_provider.dart';
import '../../providers/courses_provider.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> with TickerProviderStateMixin {
  // loading
  bool _isLoadingPagination = false;

  // Tab controller
  late TabController _tabController;

  // Số item trên mỗi trang
  final int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    loadDataPage(_tabController.index, 0, null, null, null, null, null);

    // Lấy tổng số trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
      coursesProvider.fetchTotalPages(pageSize: _pageSize);
    });
  }

  // refresh
  Future<void> loadDataPage(int tabIndex, int page, String? orderBy, String? order, String? search, int? level, String? categoryStr) async {
    setState(() {
      _isLoadingPagination = true;
    });

    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var coursesProvider = Provider.of<CoursesProvider>(context, listen: false);

    String accessToken = authProvider.token?.access?.token ?? "";

    try {
      switch (tabIndex) {
        case 0:
          await coursesProvider.fetchCoursesByPage(
            accessToken: accessToken,
            pageIndex: page,
            pageSize: _pageSize,
            orderBy: orderBy,
            order: order,
            search: search,
            level: level,
            categoryStr: categoryStr,
          );
          break;
        case 1:
          await coursesProvider.fetchEbooksByPage(
            accessToken: accessToken,
            pageIndex: page,
            pageSize: _pageSize,
            orderBy: orderBy,
            order: order,
            search: search,
            level: level,
            categoryStr: categoryStr,
          );
          break;
        case 2:
          await coursesProvider.fetchInteractiveEbooksByPage(
            accessToken: accessToken,
            pageIndex: page,
            pageSize: _pageSize,
            orderBy: orderBy,
            order: order,
            search: search,
            level: level,
            categoryStr: categoryStr,
          );
          break;
      }
    } catch (error) {
      // show message error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoadingPagination = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<CoursesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          coursesProvider.resetState();
          _tabController.index = 0;
          await loadDataPage(_tabController.index, 0, null, null, null, null, null);
          await coursesProvider.fetchTotalPages(pageSize: _pageSize);
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20),
          child: ListView(
            children: [
              SizedBox(height: 16),
              CoursesMainInfoComponent(onSearch: loadDataPage, tabIndex: _tabController.index),
              SizedBox(height: 16),
              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black38,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                onTap: (index) async {
                  coursesProvider.resetState();
                  await loadDataPage(index, 0, null, null, null, null, null);
                },
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.course),
                  Tab(text: AppLocalizations.of(context)!.ebook),
                  Tab(text: AppLocalizations.of(context)!.interactiveBook),
                ],
              ),
              SizedBox(height: 16),
              _isLoadingPagination
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : coursesProvider.courses.isEmpty
                  ? Center(
                child: Text(
                  AppLocalizations.of(context)!.no,
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListCoursesComponent(tabIndex: _tabController.index),
              if (coursesProvider.courses.isNotEmpty)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: NumberPaginator(
                      numberPages: coursesProvider.totalPages > 0 ? coursesProvider.totalPages : 1,
                      initialPage: coursesProvider.currentPage,
                      onPageChange: (int index) async {
                        await loadDataPage(_tabController.index, index, null, null, null, null, null);
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
