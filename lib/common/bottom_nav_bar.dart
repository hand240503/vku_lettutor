import 'package:flutter/material.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/courses_page/courses_page.dart';
import 'package:lettutor/pages/list_teacher_page/list_teacher_page.dart';
import 'package:lettutor/pages/schedule_page/schedule_page.dart'; // <-- import trang mới
import 'package:lettutor/pages/settingsPage/setting_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  static final PersistentTabController controller = PersistentTabController(
    initialIndex: 0,
  );
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final ValueNotifier<bool> _isVisible = ValueNotifier(true);

  PersistentBottomNavBarItem _buildNavItem({
    required IconData icon,
    required String title,
  }) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon),
      title: title,
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ListTeacherPage(),
      const CoursesPage(),
      const SchedulePage(),
      const SettingPage(),
    ];

    final items = [
      _buildNavItem(
        icon: Icons.home,
        title: AppLocalizations.of(context)!.home,
      ),
      _buildNavItem(
        icon: Icons.school,
        title: AppLocalizations.of(context)!.course,
      ),
      _buildNavItem(
        icon: Icons.calendar_today,
        title: AppLocalizations.of(context)!.schedule,
      ),
      _buildNavItem(
        icon: Icons.settings,
        title: AppLocalizations.of(context)!.settings,
      ),
    ];

    return ValueListenableBuilder<bool>(
      valueListenable: _isVisible,
      builder: (context, isVisible, _) {
        return PersistentTabView(
          context,
          controller: BottomNavBar.controller,
          screens: screens,
          items: items,
          navBarHeight: kBottomNavigationBarHeight,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          navBarStyle: NavBarStyle.style3,
        );
      },
    );
  }
}
