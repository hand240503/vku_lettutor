import 'package:flutter/material.dart';
import '../../data/model/courses/course.dart';
import '../../data/model/courses/course_topic.dart';
import '../../l10n/app_localizations.dart';
import 'components/course-card_component.dart';
import 'components/overview-course_component.dart';

class DetailCoursePage extends StatefulWidget {
  const DetailCoursePage({super.key});

  @override
  State<DetailCoursePage> createState() => _DetailCoursePageState();
}

class _DetailCoursePageState extends State<DetailCoursePage> {

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Course course = arguments['course'];

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.courseDetail, textAlign: TextAlign.center,),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20),
          child: ListView(
            children: [
              CourseCardComponent(course: course),
              SizedBox(height: 32),
              OverviewCourseComponent(course: course,)
            ],
          ),
        ));
  }
}
