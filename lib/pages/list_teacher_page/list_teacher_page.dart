import 'package:flutter/material.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/pages/list_teacher_page/components/banner_component.dart';
import 'package:lettutor/pages/list_teacher_page/components/filter_component.dart';
import 'package:number_paginator/number_paginator.dart';

class ListTeacherPage extends StatefulWidget {
  const ListTeacherPage({super.key});

  @override
  State<ListTeacherPage> createState() => _ListTeacherPageState();
}

class _ListTeacherPageState extends State<ListTeacherPage> {
  late Color myColor;
  late Size mediaSize;

  bool _isLoadingPagination = false;

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      // endDrawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerComponent(myColor: myColor),
            FilterComponent(
              onSearch: (searchTutor, specialities, nationality) {
                //    // Gọi API tìm kiếm ở đây nếu cần
              },
            ),
            Container(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: const Divider(
                height: 20,
                color: Color.fromRGBO(238, 238, 238, 60),
                thickness: 1,
              ),
            ),
            // !_isLoadingPagination
            // ListTeacherComponent(),
            //     : const SizedBox(
            //       child: Center(child: CircularProgressIndicator()),
            //     ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: NumberPaginator(
                numberPages: 5, // Ví dụ 5 trang
                onPageChange: (int index) {
                  setState(() {
                    _isLoadingPagination = true;
                  });
                  // Gọi API lấy danh sách giáo viên ở đây nếu cần
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      _isLoadingPagination = false;
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
