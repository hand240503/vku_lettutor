import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/model/courses/course.dart';
//import 'package:lettutor/pages/detailCoursePage/detail-course_page.dart';
import 'package:lettutor/utilities/const.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseCard extends StatefulWidget {
  const CourseCard({super.key, required this.course, required this.tabIndex});
  final Course course;
  final int tabIndex;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if(widget.tabIndex == 0){
          Navigator.push(
            context,
            MaterialPageRoute(
              //Todo: DetailCoursePage
              builder: (context) => Container(), //DetailCoursePage(),
              settings:
              RouteSettings(arguments: {
                'course': widget.course,
              },),
            ),
          );
        } else{

          final Uri _url = Uri.parse(widget.course.fileUrl!);
          if (!await launchUrl(_url)) {
            // Show message error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Loading url failed"),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );

          }
        }
      },
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade100, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CachedNetworkImage(
                  width: double.maxFinite,
                  fit: BoxFit.fitHeight,
                  imageUrl: widget.course.imageUrl ??
                      "https://cdn.kona-blue.com/upload/kona-blue_com/post/images/2024/09/18/457/avatar-mac-dinh-7.jpg",
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Image.network(
                      "https://cdn.kona-blue.com/upload/kona-blue_com/post/images/2024/09/18/457/avatar-mac-dinh-7.jpg"),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.course.name}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.course.description}",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${ConstValue.levelList[int.parse(widget.course.level!) == 0 ? 0 : int.parse(widget.course.level!) - 1]}  •  ${widget.course.topics?.length ?? 0} Lessons",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                ),
              ],
            ),
          )),
    );
  }
}
