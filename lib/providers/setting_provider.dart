import 'package:flutter/material.dart';

import '../utilities/themes.dart';

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale("en", "US");
  Locale get locale => _locale;

  ThemeMode _themeMode = getDeviceThemeMode();
  ThemeMode get themeMode => _themeMode;

  bool _notificationsEnabled = true; // Biến quản lý trạng thái thông báo
  bool get notificationsEnabled =>
      _notificationsEnabled; // Getter lấy trạng thái thông báo

  // Phương thức để bật/tắt chế độ tối
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Phương thức để thay đổi ngôn ngữ
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  // Phương thức để bật/tắt thông báo
  void toggleNotifications(bool isEnabled) {
    _notificationsEnabled = isEnabled;
    notifyListeners();
  }
}
