import 'package:flutter/material.dart';

class TutorProvider with ChangeNotifier {
  String _tutorName = '';
  List<String> _specialities = [];
  Map<String, bool> _nationalities = {};

  String get tutorName => _tutorName;
  List<String> get specialities => _specialities;
  Map<String, bool> get nationalities => _nationalities;

  void updateTutorName(String name) {
    _tutorName = name;
    notifyListeners();
  }

  void updateSpecialities(List<String> specialities) {
    _specialities = specialities;
    notifyListeners();
  }

  void updateNationalities(Map<String, bool> nationalities) {
    _nationalities = nationalities;
    notifyListeners();
  }

  // Method to handle search filter updates
  void updateSearchFilters(
    String name,
    List<String> specialities,
    Map<String, bool> nationalities,
  ) {
    _tutorName = name;
    _specialities = specialities;
    _nationalities = nationalities;
    notifyListeners();
  }
}
