import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lettutor/providers/courses_provider.dart';

import 'course-card.dart';

class ListCoursesComponent extends StatefulWidget {
  const ListCoursesComponent({super.key, required this.tabIndex});

  final int tabIndex;
  @override
  State<ListCoursesComponent> createState() => _ListCoursesComponentState();
}

class _ListCoursesComponentState extends State<ListCoursesComponent> {
  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context, listen: true);

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: coursesProvider.courses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CourseCard(
              course: coursesProvider.courses[index],
              tabIndex: widget.tabIndex,
            ),
          );
        });
  }
}
