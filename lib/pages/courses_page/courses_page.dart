import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/common/drawer.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/courses_page/components/courses-main-info_component.dart';
import 'package:lettutor/pages/courses_page/components/list-courses_component.dart';
import '../../providers/courses_provider.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> with TickerProviderStateMixin {
  bool _isLoadingPagination = false;
  late TabController _tabController;
  final int _pageSize = 5;

  String? _currentOrderBy;
  String? _currentOrder;
  String? _currentSearch;
  List<int>? _currentLevel;
  List<String>? _currentCategoryStr;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    loadDataPage(_tabController.index, 0, null, null, null, null, null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
      coursesProvider.fetchTotalPages(
        pageSize: _pageSize,
        collectionName: _getCollectionName(_tabController.index),
        search: _currentSearch,
        level: _currentLevel,
        categoryStr: _currentCategoryStr
      );
    });
  }

  String _getCollectionName(int tabIndex) {
    switch (tabIndex) {
      case 0: return "courses";
      case 1: return "ebooks";
      case 2: return "interactive_ebooks";
      default: return "courses";
    }
  }

Future<void> loadDataPage(int tabIndex, int page, String? orderBy, String? order,
    String? search, List<int>? level, List<String>? categoryStr) async {
  setState(() {
    _isLoadingPagination = true;
  });

  var coursesProvider = Provider.of<CoursesProvider>(context, listen: false);

  bool filtersChanged = false;

  if (orderBy != _currentOrderBy ||
      order != _currentOrder ||
      search != _currentSearch ||
      level != _currentLevel ||
      categoryStr != _currentCategoryStr) {
    filtersChanged = true;
  }

  if (filtersChanged) {
    coursesProvider.setCurrentPage(0);
    page = 0;
    _currentOrderBy = orderBy;
    _currentOrder = order;
    _currentSearch = search;
    _currentLevel = level;
    _currentCategoryStr = categoryStr;
  }

  try {
    switch (tabIndex) {
      case 0:
        await coursesProvider.fetchCoursesByPage(
          pageIndex: page,
          pageSize: _pageSize,
          orderBy: _currentOrderBy,
          order: _currentOrder,
          search: _currentSearch,
          level: _currentLevel,
          categoryStr: _currentCategoryStr,
        );
        break;
      case 1:
        await coursesProvider.fetchEbooksByPage(
          pageIndex: page,
          pageSize: _pageSize,
          orderBy: _currentOrderBy,
          order: _currentOrder,
          search: _currentSearch,
          level: _currentLevel,
          categoryStr: _currentCategoryStr,
        );
        break;
      case 2:
        await coursesProvider.fetchInteractiveEbooksByPage(
          pageIndex: page,
          pageSize: _pageSize,
          orderBy: _currentOrderBy,
          order: _currentOrder,
          search: _currentSearch,
          level: _currentLevel,
          categoryStr: _currentCategoryStr,
        );
        break;
    }

    await coursesProvider.fetchTotalPages(
      pageSize: _pageSize,
      collectionName: _getCollectionName(tabIndex),
        search: _currentSearch,
        level: _currentLevel,
        categoryStr: _currentCategoryStr
    );

    debugPrint("Current pageeee: ${coursesProvider.courses.toString()}");
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
    final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
    coursesProvider.resetState(resetFilters: false); // Keep filters
    _tabController.index = 0;
    await loadDataPage(
        _tabController.index,
        0,
        _currentOrderBy,
        _currentOrder,
        _currentSearch,
        _currentLevel,
        _currentCategoryStr
    );
    await coursesProvider.fetchTotalPages(
      pageSize: _pageSize,
      collectionName: _getCollectionName(_tabController.index),
      search: _currentSearch,
      level: _currentLevel,
      categoryStr: _currentCategoryStr
    );
  }

  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<CoursesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CustomDrawer(),
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              CoursesMainInfoComponent(
                onSearch: loadDataPage,
                tabIndex: _tabController.index,
                currentOrderBy: _currentOrderBy,
                currentOrder: _currentOrder,
                currentSearch: _currentSearch,
                currentLevel: _currentLevel,
                currentCategoryStr: _currentCategoryStr,
              ),
              const SizedBox(height: 16),
              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black38,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                onTap: (index) async {
                  coursesProvider.resetState(resetFilters: false);
                  await loadDataPage(
                      index,
                      0,
                      _currentOrderBy,
                      _currentOrder,
                      _currentSearch,
                      _currentLevel,
                      _currentCategoryStr
                  );
                  await coursesProvider.fetchTotalPages(
                    pageSize: _pageSize,
                    collectionName: _getCollectionName(index),
                    search: _currentSearch,
                    level: _currentLevel,
                    categoryStr: _currentCategoryStr
                  );
                },
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.course),
                  Tab(text: AppLocalizations.of(context)!.ebook),
                  Tab(text: AppLocalizations.of(context)!.interactiveBook),
                ],
              ),
              const SizedBox(height: 16),
              _buildContent(coursesProvider),
              if (coursesProvider.courses.isNotEmpty)
                _buildPaginator(coursesProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(CoursesProvider coursesProvider) {
    if (_isLoadingPagination) {
      return const Center(child: CircularProgressIndicator());
    } else if (coursesProvider.courses.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.no,
          style: const TextStyle(fontSize: 16),
        ),
      );
    } else {
      return ListCoursesComponent(tabIndex: _tabController.index);
    }
  }

  Widget _buildPaginator(CoursesProvider coursesProvider) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: NumberPaginator(
        numberPages: coursesProvider.totalPages > 0 ? coursesProvider.totalPages : 1,
        initialPage: coursesProvider.currentPage,
        onPageChange: (int index) async {
          // Use current filter values instead of null
          await loadDataPage(
              _tabController.index,
              index,
              _currentOrderBy,
              _currentOrder,
              _currentSearch,
              _currentLevel,
              _currentCategoryStr
          );
        },
      ),
    );
  }
}