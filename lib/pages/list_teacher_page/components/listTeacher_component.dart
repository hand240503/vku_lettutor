import 'package:flutter/material.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/detailTeacherPage/detail-a-teacher_page.dart';
import 'package:lettutor/pages/list_teacher_page/components/tutorTeacherCard.dart';
import 'package:lettutor/providers/tutor_provider.dart';
import 'package:provider/provider.dart';

class ListTeacherComponent extends StatefulWidget {
  const ListTeacherComponent({super.key});

  @override
  State<ListTeacherComponent> createState() => _ListTeacherComponentState();
}

class _ListTeacherComponentState extends State<ListTeacherComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TutorProvider tutorProvider = context.watch<TutorProvider>();

    return Container(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.recommendTutors,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          if (tutorProvider.tutors.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  AppLocalizations.of(context)!.noTutorsAvailable,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tutorProvider.tutors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailATeacherPage(),
                        settings: RouteSettings(
                          arguments: {
                            'tutor': tutorProvider.tutors[index],
                            'index': index,
                          },
                        ),
                      ),
                    );
                  },
                  child: TutorTeacherCard(
                    tutor: tutorProvider.tutors[index],
                    isFavorite: true,
                    onClickFavorite: () {},
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
