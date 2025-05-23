import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lettutor/l10n/app_localizations.dart';

class BirthdayProfileSelect extends StatefulWidget {
  const BirthdayProfileSelect({
    super.key,
    this.dateTimeData,
    required this.onBirthDayChanged,
  });
  final DateTime? dateTimeData;
  final ValueChanged<String> onBirthDayChanged;

  @override
  State<BirthdayProfileSelect> createState() => _BirthdayProfileSelectState();
}

class _BirthdayProfileSelectState extends State<BirthdayProfileSelect> {
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  bool isInitValue = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        (await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        ))!;

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.toLocal()}".split(' ')[0];
        widget.onBirthDayChanged(selectedDate.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitValue) {
      dateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(widget.dateTimeData!);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 42,
          child: TextField(
            controller: dateController,
            decoration: InputDecoration(
              isDense: true, // Added this
              hintText: AppLocalizations.of(context)!.chooseYourBirthday,
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
              ), // Điều chỉnh khoảng cách nội dung
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_today),
              ),
            ),
            readOnly: true, // To prevent manual text input
          ),
        ),
      ],
    );
  }
}
