import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multiselect/multiselect.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../providers/courses_provider.dart';
import '../../../utilities/const.dart';

class CoursesMainInfoComponent extends StatefulWidget {
  final String? currentOrderBy;
  final String? currentOrder;
  final String? currentSearch;
  final List<int>? currentLevel;
  final List<String>? currentCategoryStr;

  const CoursesMainInfoComponent({super.key, required this.onSearch, required this.tabIndex,
    this.currentOrderBy, this.currentOrder, this.currentSearch, this.currentLevel, this.currentCategoryStr,
  });

  final Function(int tabIndex, int page, String? orderBy, String? order, String? search, List<int>? level, List<String>? categoryStr) onSearch;
  final int tabIndex;

  @override
  State<CoursesMainInfoComponent> createState() => _CoursesMainInfoComponentState();
}

class _CoursesMainInfoComponentState extends State<CoursesMainInfoComponent> {
  bool isSearching = false;
  final TextEditingController _textSearchController = TextEditingController();

  // Filter options
  List<String> itemsLevel = [];
  List<String> itemsCategory = [];
  final List<String> itemsSort = ["Level decreasing", "Level ascending"];

  // Selected filter values
  List<String> selectedLevel = [];
  List<String> selectedCategory = [];
  List<String> selectedSort = [];

  // Category mapping and loading state
  Map<String, String> categoryMap = {};
  bool isLoadingCategories = false;

  @override
  void initState() {
    super.initState();
    itemsLevel = List<String>.from(ConstValue.levelList);

    _fetchCategoriesFromFirebase();

    if (widget.currentLevel != null && widget.currentLevel!.isNotEmpty) {
      selectedLevel = widget.currentLevel!.map((index) => ConstValue.levelList[index]).toList();
    }

    if (widget.currentCategoryStr != null && widget.currentCategoryStr!.isNotEmpty) {
      selectedCategory = widget.currentCategoryStr!;
    }

    if (widget.currentOrderBy == "level" && widget.currentOrder != null) {
      selectedSort = [widget.currentOrder == "asc" ? "Level ascending" : "Level decreasing"];
    }

    if (widget.currentSearch != null) {
      _textSearchController.text = widget.currentSearch!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchCourse(),
          const SizedBox(height: 16),
          _buildSubTitle(),
          const SizedBox(height: 16),
          _buildSelect(AppLocalizations.of(context)!.selectLevel, itemsLevel, selectedLevel),
          const SizedBox(height: 16),
          isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : _buildSelect(AppLocalizations.of(context)!.selectCategory, itemsCategory, selectedCategory),
          const SizedBox(height: 16),
          _buildSelect(AppLocalizations.of(context)!.sortByLevel, itemsSort, selectedSort),
        ],
      ),
    );
  }

  Widget _buildSearchCourse() {
    return Row(
      children: [
        SvgPicture.asset(
          'lib/assets/images/course.svg',
          semanticsLabel: "Course",
          height: 100,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.discoverCourse,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _textSearchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        hintText: 'Search ...',
                        isDense: true,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        contentPadding: const EdgeInsets.all(8),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: _resetFilters,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: handleSearch,
                        icon: isSearching
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                ),
                              )
                            : const Icon(
                                Icons.search_rounded,
                                size: 24,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSubTitle() {
    return Text(
      AppLocalizations.of(context)!.discoverCourseSubTitle,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 16, color: Colors.black38, height: 1.2),
    );
  }

  Widget _buildSelect(String title, List<String> selects, List<String> selected) {
    return SizedBox(
      height: 42,
      child: DropDownMultiSelect(
        isDense: true,
        childBuilder: (selectedItems) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              selectedItems.isEmpty ? title : selectedItems.join(", "),
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
        onChanged: (List<String> x) {
          setState(() {
            if (title == AppLocalizations.of(context)!.selectLevel) {
              selectedLevel = x;
            } else if (title == AppLocalizations.of(context)!.selectCategory) {
              selectedCategory = x;
            } else if (title == AppLocalizations.of(context)!.sortByLevel) {
              selectedSort = x.isNotEmpty ? [x.last] : [];
            }
            handleSearch();
          });
        },
        options: selects,
        selectedValues: selected,
        whenEmpty: title,
      ),
    );
  }

  String _getCollectionName(int tabIndex) {
    switch (tabIndex) {
      case 0: return "courses";
      case 1: return "ebooks";
      case 2: return "interactive_ebooks";
      default: return "courses";
    }
  }

  void handleSearch() async {
    setState(() {
      isSearching = true;
    });

    final String? search = _textSearchController.text.isEmpty ? null : _textSearchController.text;
    final List<int>? level = selectedLevel.isNotEmpty
        ? selectedLevel.map((e) => ConstValue.levelList.indexOf(e)).toList()
        : null;

    final List<String>? categoryStr = selectedCategory.isNotEmpty
        ? selectedCategory
            .map((title) => categoryMap.entries.firstWhere(
                  (e) => e.value == title,
                  orElse: () => const MapEntry('', ''),
                ).key)
            .where((id) => id.isNotEmpty)
            .toList()
        : null;

    String? orderBy;
    String? order;
    if (selectedSort.isNotEmpty) {
      orderBy = "level";
      order = selectedSort[0] == "Level ascending" ? "asc" : "desc";
    }

    await widget.onSearch(widget.tabIndex, 0, orderBy, order, search, level, categoryStr);

    final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
    await coursesProvider.fetchTotalPages(pageSize: 5, collectionName: _getCollectionName(widget.tabIndex),
      search: search, level: level, categoryStr: categoryStr);

    if (!mounted) return;
    setState(() {
      isSearching = false;
    });
  }

  void _fetchCategoriesFromFirebase() async {
    if (!mounted) return;
    setState(() {
      isLoadingCategories = true;
    });

    try {
      final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
      final categories = await coursesProvider.fetchCategories();

      if (!mounted) return;
      setState(() {
        categoryMap = categories;
        itemsCategory = categories.values.toList();

        if (widget.currentCategoryStr != null && widget.currentCategoryStr!.isNotEmpty) {
          selectedCategory = widget.currentCategoryStr!
              .map((id) => categories[id])
              .whereType<String>()
              .toList();
        }
      });
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingCategories = false;
        });
      }
    }
  }

  void _resetFilters() {
    setState(() {
      _textSearchController.clear();
      selectedLevel.clear();
      selectedCategory.clear();
      selectedSort.clear();
    });

    handleSearch();
  }
}