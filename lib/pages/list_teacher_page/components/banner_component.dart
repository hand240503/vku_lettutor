import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lettutor/providers/schedule_provider.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';

class BannerComponent extends StatefulWidget {
  final Color myColor;

  const BannerComponent({super.key, required this.myColor});

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  @override
  Widget build(BuildContext context) {
    // Lấy số lượng lịch học từ ScheduleProvider
    final totalSchedules = context.watch<ScheduleProvider>().totalSchedules;

    return Container(
      color: const Color.fromRGBO(7, 96, 191, 1.0),
      padding: const EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        children: [
          Container(
            child: Text(
              AppLocalizations.of(context)!.upComingLesson,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 16),
          // Kiểm tra số lượng lịch học
          totalSchedules > 0
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.youHaveScheduledLessons,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.noUpcomingLesson,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          SizedBox(height: 16),
          Container(
            child: Text(
              "${AppLocalizations.of(context)!.totalLessonTime} $totalSchedules",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget build Timer
  Widget buildTimer(BuildContext context) {
    // Dữ liệu tĩnh cho thời gian bắt đầu và kết thúc
    final startTimestamp =
        1672531199000; // Ví dụ timestamp cho thời gian bắt đầu (thay bằng giá trị thực tế của bạn)
    final endTimestamp =
        1672534799000; // Ví dụ timestamp cho thời gian kết thúc (thay bằng giá trị thực tế của bạn)

    // Chuyển đổi timestamp thành ngày và giờ
    final startDate = DateFormat(
      'E, d MMM y',
    ).format(DateTime.fromMillisecondsSinceEpoch(startTimestamp));
    final startTime = DateFormat(
      'HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(startTimestamp));
    final endTime = DateFormat(
      'HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(endTimestamp));

    return Column(
      children: [
        Text(
          '$startDate\n$startTime - $endTime',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              '(starts in: ',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.yellow,
              ),
            ),
            Text(
              '---', // Hiển thị dấu ba gạch chéo thay vì đồng hồ đếm ngược
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.yellow,
              ),
            ),
            Text(
              ')',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
