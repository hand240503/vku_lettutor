import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleProvider with ChangeNotifier {
  List<Map<String, dynamic>> _schedules = [];

  List<Map<String, dynamic>> get schedules => _schedules;

  ScheduleProvider() {
    loadSchedules(); // This will call the method to load schedules when the provider is created
  }

  // Load schedules from shared preferences
  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? scheduleList = prefs.getStringList('schedules');
    if (scheduleList != null) {
      _schedules =
          scheduleList
              .map(
                (e) => Map<String, dynamic>.from({
                  'name': e.split(',')[0],
                  'start': DateTime.parse(e.split(',')[1]),
                  'end': DateTime.parse(e.split(',')[2]),
                }),
              )
              .toList();
    }
    notifyListeners(); // Notify listeners after loading data
  }

  // Add a new schedule
  Future<void> addSchedule(DateTime start, DateTime end, String name) async {
    final newSchedule = {'name': name, 'start': start, 'end': end};
    _schedules.add(newSchedule);

    // Save to SharedPreferences
    await _saveSchedules();
    notifyListeners();
  }

  // Update an existing schedule
  Future<void> updateSchedule(
    int index,
    DateTime start,
    DateTime end,
    String name,
  ) async {
    final updatedSchedule = {'name': name, 'start': start, 'end': end};
    _schedules[index] = updatedSchedule;

    // Save to SharedPreferences
    await _saveSchedules();
    notifyListeners();
  }

  // Remove a schedule
  Future<void> removeSchedule(int index) async {
    _schedules.removeAt(index);

    // Save to SharedPreferences
    await _saveSchedules();
    notifyListeners();
  }

  // Helper method to save schedules to SharedPreferences
  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleList =
        _schedules
            .map(
              (e) =>
                  '${e['name']},${e['start'].toIso8601String()},${e['end'].toIso8601String()}',
            )
            .toList();
    await prefs.setStringList('schedules', scheduleList);
  }

  int get totalSchedules => _schedules.length;
}
