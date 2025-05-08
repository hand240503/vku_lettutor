import 'package:flutter/material.dart';
import 'package:lettutor/common/bottom_nav_bar.dart';
import 'package:lettutor/pages/courses_page/courses_page.dart';
import 'package:lettutor/pages/detail_course_page/detail-course_page.dart';
import 'package:lettutor/pages/forgot-password_page/forgot-password_page.dart';
import 'package:lettutor/pages/list_teacher_page/list_teacher_page.dart';
import 'package:lettutor/pages/login_page/login_page.dart';
import 'package:lettutor/pages/profilePage/components/forgot_profile_page.dart';
import 'package:lettutor/pages/profilePage/profile_page.dart';
import 'package:lettutor/pages/schedule_page/schedule_page.dart';
import 'package:lettutor/pages/sign-up_page/sign-up_page.dart';

class AppRoutes {
  static const String bottomNavBar          = '/bottomNavBar';
  static const String login                 = '/loginPage';
  static const String signUp                = '/signUpPage';
  static const String forgotPassword        = '/forgotPasswordPage';
  static const String listTeacher           = '/listTeacherPage';
  static const String courses               = '/coursesPage';
  static const String detailCourse          = '/detailCoursePage';
  static const String profile               = '/profilePage';
  static const String forgotProfilePage     = '/forgotProfilePage';
  static const String schedulePage          = '/schedulePage';
  static Map<String, WidgetBuilder> get routes {
    return {
      login:              (context) => const LoginPage(),
      signUp:             (context) => const SignUpPage(),
      forgotPassword:     (context) => const ForgotPasswordPage(),
      listTeacher:        (context) => const ListTeacherPage(),
      courses:            (context) => const CoursesPage(),
      detailCourse:       (context) => const DetailCoursePage(),
      profile:            (context) => const ProfilePage(),
      bottomNavBar:       (context) => const BottomNavBar(),
      forgotProfilePage:  (context) => const ForgotProfilePage(),
      schedulePage:       (context) => const SchedulePage(),
    };
  }
}
