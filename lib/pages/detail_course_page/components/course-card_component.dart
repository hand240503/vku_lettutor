import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../data/model/courses/course.dart';
import '../../../l10n/app_localizations.dart';
import '../../detail_lesson_page/detail-lesson_page.dart';
//import '../../detailLessonPage/detail-lesson_page.dart';

class CourseCardComponent extends StatelessWidget {
  const CourseCardComponent({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade100, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: CachedNetworkImage(
                width: double.maxFinite,
                fit: BoxFit.fitHeight,
                imageUrl: course.imageUrl ?? "https://i.imgur.com/CUJIwAC.png",
                progressIndicatorBuilder:
                    (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                errorWidget:
                    (context, url, error) =>
                        Image.network("https://i.imgur.com/CUJIwAC.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 24,),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 32, bottom: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      course.name!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      course.description!,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            //TODO: Chưa có trang DetailLessonPage
                            builder: (context) => DetailLessonPage(),
                            settings: RouteSettings(
                              arguments: {'course': course, 'index': 0},
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text(AppLocalizations.of(context)!.discover),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
