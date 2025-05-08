import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class TableCalendar extends StatelessWidget {
  final Function(DateTime, DateTime) onSelectDate;

  const TableCalendar({Key? key, required this.onSelectDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      firstDayOfWeek: DateTime.now().weekday,
      minDate: DateTime.now(),
      onTap: (details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          DateTime selectedDate = details.date!;
          DateTime endTime = selectedDate.add(const Duration(hours: 1)); // Assuming 1 hour for each session

          onSelectDate(selectedDate, endTime);
        }
      },
    );
  }
}
