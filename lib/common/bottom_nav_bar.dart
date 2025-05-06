import 'package:flutter/material.dart';
import 'package:lettutor/pages/courses_page/courses_page.dart';
import 'package:lettutor/pages/list_teacher_page/list_teacher_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );
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
    final screens = [const ListTeacherPage(), const CoursesPage()];

    final items = [
      _buildNavItem(icon: Icons.home, title: 'Home'),
      _buildNavItem(icon: Icons.school, title: 'Courses'),
    ];

    return ValueListenableBuilder<bool>(
      valueListenable: _isVisible,
      builder: (context, isVisible, _) {
        return PersistentTabView(
          context,
          controller: _controller,
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
