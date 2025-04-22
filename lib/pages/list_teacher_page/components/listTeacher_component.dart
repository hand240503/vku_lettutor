import 'package:flutter/material.dart';
import 'package:lettutor/l10n/app_localizations.dart';

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
    // TutorProvider tutorProvider = context.watch<TutorProvider>(); // Dùng khi có dữ liệu thật
    // var authProvider = Provider.of<AuthProvider>(context);

    // Danh sách cứng giả lập dữ liệu
    List<Map<String, String>> staticTutors = [
      {'name': 'John Doe', 'subject': 'Mathematics', 'userId': '1'},
      {'name': 'Jane Smith', 'subject': 'Science', 'userId': '2'},
      {'name': 'Michael Johnson', 'subject': 'History', 'userId': '3'},
    ];

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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                staticTutors.length, // Thay đổi từ tutorProvider.tutors.length
            itemBuilder: (context, index) {
              var tutor = staticTutors[index];
              return GestureDetector(
                // onTap: () {
                //   // Điều hướng đến chi tiết giảng viên
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => DetailATeacherPage(),
                //       settings: RouteSettings(
                //         arguments: {'tutor': tutor, 'index': index},
                //       ),
                //     ),
                //   );
                // },
                // child: TutorTeacherCard(
                //   tutor: tutor, // Truyền đối tượng tutor giả lập vào
                //   isFavorite: false, // Mặc định là chưa được yêu thích
                //   onClickFavorite: () {
                //     // Xử lý sự kiện chọn yêu thích
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text(
                //           AppLocalizations.of(context)!.favoriteMessage,
                //         ),
                //         duration: Duration(seconds: 1),
                //         behavior: SnackBarBehavior.floating,
                //         backgroundColor: Colors.green,
                //       ),
                //     );
                //   },
                // ),
              );
            },
          ),
        ],
      ),
    );
  }
}
