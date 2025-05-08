import 'package:flutter/material.dart';
import 'package:lettutor/pages/quiz_page/quiz_page.dart';
//import 'package:src/pages/detailLessonPage/detail-lesson_page.dart';
import '../../../common/bottom_nav_bar.dart';
import '../../../data/model/courses/course.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utilities/const.dart';
import '../../detail_lesson_page/detail-lesson_page.dart';

class OverviewCourseComponent extends StatelessWidget {
  const OverviewCourseComponent({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildTitle(AppLocalizations.of(context)!.overview),
        SizedBox(height: 20),
        _buildSubTitle(Icons.question_mark,
            AppLocalizations.of(context)!.whyTakeThisCourse, Colors.red),
        SizedBox(height: 8),
        _buildSubDescription(course.reason ?? CourseOverView.takenReason),
        SizedBox(height: 20),
        _buildSubTitle(Icons.question_mark,
            AppLocalizations.of(context)!.whatAbleToDo, Colors.red),
        SizedBox(height: 8),
        _buildSubDescription(course.purpose ?? CourseOverView.achievement),
        SizedBox(height: 20),
        _buildTitle(AppLocalizations.of(context)!.experienceLevel),
        SizedBox(height: 20),
        _buildSubTitle(
            Icons.group_add,
            ConstValue.levelList[int.parse(course.level!) == 0
                ? 0
                : int.parse(course.level!) - 1],
            Colors.blueAccent),
        SizedBox(height: 20),
        _buildTitle(AppLocalizations.of(context)!.courseLength),
        SizedBox(height: 20),
        _buildSubTitle(
            Icons.topic,
            "${course.topics?.length ?? 0} ${AppLocalizations.of(context)!.topics}",
            Colors.blueAccent),
        SizedBox(height: 20),
        _buildTitle(AppLocalizations.of(context)!.listOfTopic),
        SizedBox(height: 20),
        _buildListTopics(context)
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
    );
  }

  Widget _buildSubTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 16,
              fontWeight: FontWeight.normal),
        )
      ],
    );
  }

  Widget _buildSubDescription(String text) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.normal,
            fontSize: 14,
            height: 1.3),
      ),
    );
  }

  Widget _buildListTopics(BuildContext context) {
    final topicLength = course.topics?.length ?? 0;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: topicLength + 1, // Thêm 1 cho Quiz Test
      itemBuilder: (BuildContext context, int index) {
        if (index < topicLength) {
          return _buildItemList(index + 1, context);
        } else {
          return _buildQuizItem(context, topicLength + 1);
        }
      },
    );
  }


  Widget _buildItemList(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        // Xử lý sự kiện khi mục được nhấp vào
        Navigator.push(
          context,
          MaterialPageRoute(
            //TODO: Chưa có trang DetailLessonPage
            builder: (context) => DetailLessonPage(),
            settings: RouteSettings(
              arguments: {'course': course, 'index': index - 1},
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        color: Colors.white,
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            color: Colors.grey.shade100,

          ),
          padding: EdgeInsets.only(left: 12, right: 12, top: 28, bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$index.',
                style: const TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'TT Commons Pro Regular',),
              ),
              SizedBox(height: 10),
              Text(
                course.topics?[index - 1].name ?? "No title",
                style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  fontFamily: 'TT Commons Pro Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage()
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        color: Colors.white,
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orangeAccent),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            color: Colors.orange.shade50,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 1),
              )
            ],
          ),
          padding: EdgeInsets.only(left: 12, right: 12, top: 28, bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$index.',
                style: const TextStyle(color: Colors.black, fontSize: 17,fontFamily: 'TT Commons Pro Regular',),
              ),
              SizedBox(height: 10),
              Text(
                "🎯 Quiz Test",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'TT Commons Pro Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
