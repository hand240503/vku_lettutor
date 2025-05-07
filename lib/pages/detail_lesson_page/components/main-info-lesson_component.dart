import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../data/model/courses/course.dart';

class InfoLessonComponent extends StatefulWidget {
  const InfoLessonComponent(
      {super.key, required this.course, required this.index});

  final Course course;
  final int index;

  @override
  _InfoLessonComponentState createState() => _InfoLessonComponentState();
}

class _InfoLessonComponentState extends State<InfoLessonComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
          width: double.maxFinite,
          fit: BoxFit.fitHeight,
          imageUrl: widget.course.imageUrl ??
              "https://i.imgur.com/CUJIwAC.png",
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => Image.network(
              "https://i.imgur.com/CUJIwAC.png"),
        ),
        Container(
          padding: const EdgeInsets.only(top: 32, bottom: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.course.name ?? "No title",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.course.description ?? "No description",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
