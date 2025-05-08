import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/common/drawer.dart';
import 'package:lettutor/data/services/noti_service.dart';
import 'package:lettutor/pages/schedule_page/components/info-page_component.dart';
import 'package:lettutor/pages/schedule_page/components/task_cart.dart';
import 'package:provider/provider.dart';

import '../../providers/schedule_provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _nameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CustomDrawer(),
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              const InfoPageScheduleComponent(),
              const SizedBox(height: 20),
              _buildScheduleForm(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_startDate != null &&
                      _endDate != null &&
                      _nameController.text.isNotEmpty) {
                    _saveSchedule();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  }
                },
                child: const Text('Save Schedule'),
              ),
              const SizedBox(height: 20),
              _buildScheduleList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    setState(() {
      _isLoading = true;
    });
    await context.read<ScheduleProvider>().loadSchedules();
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildScheduleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Schedule Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _pickStartDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Date & Time',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _startDate == null
                        ? 'Select Start Time'
                        : DateFormat('yyyy-MM-dd HH:mm').format(_startDate!),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: _pickEndDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'End Date & Time',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _endDate == null
                        ? 'Select End Time'
                        : DateFormat('yyyy-MM-dd HH:mm').format(_endDate!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay currentTime = TimeOfDay.fromDateTime(DateTime.now());

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: currentTime, // Đặt thời gian ban đầu là giờ hiện tại
      );

      if (pickedTime != null) {
        final selectedStartDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Kiểm tra nếu thời gian bắt đầu là trong quá khứ
        if (selectedStartDate.isBefore(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Start date cannot be in the past')),
          );
          return;
        }

        setState(() {
          _startDate = selectedStartDate;
        });
      }
    }
  }

  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start time first')),
      );
      return;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay currentTime = TimeOfDay.fromDateTime(DateTime.now());
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: currentTime,
      );

      if (pickedTime != null) {
        final selectedEndDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Kiểm tra nếu thời gian kết thúc là trước thời gian bắt đầu
        if (selectedEndDate.isBefore(_startDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('End date cannot be before start date'),
            ),
          );
          return;
        }

        setState(() {
          _endDate = selectedEndDate;
        });
      }
    }
  }

  Future<void> _saveSchedule() async {
    // Lưu lịch vào provider
    await context.read<ScheduleProvider>().addSchedule(
      _startDate!,
      _endDate!,
      _nameController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule saved successfully!')),
    );

    // Thêm thông báo cục bộ
    await LocalNotificationService().showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Lịch mới',
      body: 'Bạn đã thêm lịch "${_nameController.text}" thành công!',
      payload: 'schedule_added',
    );

    setState(() {
      _nameController.clear();
      _startDate = null;
      _endDate = null;
    });

    refresh();
  }

  Future<void> _deleteSchedule(int index) async {
    final schedule = context.read<ScheduleProvider>().schedules[index];
    await context.read<ScheduleProvider>().removeSchedule(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule deleted successfully!')),
    );

    await LocalNotificationService().showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Đã xóa lịch',
      body: 'Lịch "${schedule['name']}" đã được xóa.',
      payload: 'schedule_deleted',
    );

    refresh();
  }

  // Build list of saved schedules
  Widget _buildScheduleList() {
    final schedules = context.watch<ScheduleProvider>().schedules;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return TaskCard(
          size: MediaQuery.of(context).size,
          index: index,
          title: schedule['name'],
          subTitle:
              'Start: ${DateFormat('yyyy-MM-dd HH:mm').format(schedule['start'])}\nEnd: ${DateFormat('yyyy-MM-dd HH:mm').format(schedule['end'])}',
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteSchedule(index);
            },
          ),
        );
      },
    );
  }
}
