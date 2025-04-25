import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/tutor/tutor.dart';
import '../../../providers/tutor_provider.dart';

class TutorTeacherCard extends StatefulWidget {
  final Tutor tutor;
  final bool isFavorite;
  final VoidCallback onClickFavorite;

  const TutorTeacherCard({
    super.key,
    required this.tutor,
    required this.isFavorite,
    required this.onClickFavorite,
  });

  @override
  _TutorTeacherCardState createState() => _TutorTeacherCardState();
}

class _TutorTeacherCardState extends State<TutorTeacherCard> {
  late bool _isFavored;
  @override
  void initState() {
    super.initState();
    _isFavored = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    TutorProvider tutorProvider = context.watch<TutorProvider>();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade100, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        width: double.maxFinite,
                        fit: BoxFit.fitHeight,
                        imageUrl:
                            widget.tutor.avatar ??
                            "https://sandbox.api.lettutor.com/avatar/f569c202-7bbf-4620-af77-ecc1419a6b28avatar1700296337596.jpg",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Image.network(
                              "https://sandbox.api.lettutor.com/avatar/f569c202-7bbf-4620-af77-ecc1419a6b28avatar1700296337596.jpg",
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.tutor.name ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    // SvgPicture.asset('lib/assets/images/vietnam.svg',
                    //     semanticsLabel: "My SVG", height: 20),
                    // SizedBox(width: 5),
                    Text(
                      widget.tutor.country ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < 5; i++)
                  Icon(
                    i < (widget.tutor.rating == null ? 0 : widget.tutor.rating!)
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.yellow,
                    size: 16,
                  ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                //Navigator.pushNamed(context, '/schedulePage');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_card_rounded, // Use the book icon
                    color: Colors.blue, // Icon color
                  ),
                  SizedBox(
                    width: 8,
                  ), // Create a space between the icon and the text
                  Text(
                    'Book',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.blue,
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

  // List<String> convertKeysToNames(String keys) {
  //   List<String> keyList = keys.split(',');
  //   List<String> result = [];

  //   for (String key in keyList) {
  //     for (TestPreparation speciality in Specialities.specialities) {
  //       if (key == speciality.key) {
  //         result.add(speciality.name!);
  //         break;
  //       }
  //     }

  //     for (LearnTopic topic in Specialities.topics) {
  //       if (key == topic.key) {
  //         result.add(topic.name!);
  //         break;
  //       }
  //     }
  //   }

  //   return result;
  // }
}
