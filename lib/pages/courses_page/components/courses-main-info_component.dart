import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multiselect/multiselect.dart';
import 'package:lettutor/l10n/app_localizations.dart';

import '../../../utilities/const.dart';

class CoursesMainInfoComponent extends StatefulWidget {
  const CoursesMainInfoComponent({super.key, required this.onSearch, required this.tabIndex});
  final Function(int tabIndex, int page, String? orderBy, String? order, String? search, int? level, String? categoryStr) onSearch;
  final int tabIndex;

  @override
  State<CoursesMainInfoComponent> createState() =>
      _CoursesMainInfoComponentState();
}

class _CoursesMainInfoComponentState extends State<CoursesMainInfoComponent> {
  bool isSearching = false;
  // text search controller
  TextEditingController _textSearchController = TextEditingController();
  List<String> itemsLevel = [];
  List<String> itemsCategory = [];
  List<String> itemsSort = ["Level decreasing", "Level ascending"];

  List<String> selectedLevel = [];
  List<String> selectedCategory = [];
  List<String> selectedSort = [];

  @override
  void initState() {
    // TODO: implement initState

    for (var element in ConstValue.levelList) {
      itemsLevel.add(element);
    }
    for (var element in Specialities.specialities) {
      itemsCategory.add(element.name!);
    }
    for (var element in Specialities.topics) {
      itemsCategory.add(element.name!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchCourse(),
          SizedBox(height: 16),
          _buildSubTitle(),
          // SizedBox(height: 16),
          // _buildSelect("Select level", itemsLevel, selectedLevel),
          // SizedBox(height: 16),
          // _buildSelect("Select category", itemsCategory, selectedCategory),
          // SizedBox(height: 16),
          // _buildSelect("Sort by level", itemsSort, selectedSort),
        ],
      ),
    );
  }

  Widget _buildSearchCourse() {
    return Row(
      children: [
        SvgPicture.asset('lib/assets/images/course.svg',
            semanticsLabel: "Course", height: 100),
        SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.discoverCourse,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
              SizedBox(height: 8),
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
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: Container(
                      color: Colors.grey.shade100,
                      child: IconButton(
                        onPressed: () {
                          handleSearch();
                        },
                        icon: isSearching
                            ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        )
                            : Icon(
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
      style: TextStyle(fontSize: 16, color: Colors.black38, height: 1.2),
    );
  }

  Widget _buildSelect(
      String title, List<String> selects, List<String> selected) {
    return SizedBox(
      height: 42,
      child: DropDownMultiSelect(
        isDense: true,
        onChanged: (List<String> x) {
          setState(() {
            selected = x;
          });
        },
        options: selects,
        selectedValues: selected,
        whenEmpty: title,
      ),
    );
  }


  void handleSearch() async {
    setState(() {
      isSearching = true;
    });

    String? search = _textSearchController.text.isEmpty ? null : _textSearchController.text;

    await widget.onSearch(widget.tabIndex, 1, null, null, search, null, null);

    setState(() {
      isSearching = false;
    });
  }

}
