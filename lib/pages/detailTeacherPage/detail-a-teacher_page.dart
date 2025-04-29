import 'package:flutter/material.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/data/model/tutor/tutor.dart';
import 'package:lettutor/pages/detailTeacherPage/components/info_component.dart';

class DetailATeacherPage extends StatefulWidget {
  const DetailATeacherPage({super.key});

  @override
  State<DetailATeacherPage> createState() => _DetailATeacherPageState();
}

class _DetailATeacherPageState extends State<DetailATeacherPage> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Tutor tutor = arguments['tutor'];
    final int index = arguments['index'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showMenu: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [InfoComponent(tutor: tutor, index: index)]),
      ),
    );
  }
}
