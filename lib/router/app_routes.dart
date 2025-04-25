import 'package:flutter/material.dart';
import 'package:lettutor/pages/forgot-password_page/forgot-password_page.dart';
import 'package:lettutor/pages/list_teacher_page/list_teacher_page.dart';
import 'package:lettutor/pages/login_page/login_page.dart';
import 'package:lettutor/pages/sign-up_page/sign-up_page.dart';

class AppRoutes {
  static const String login = '/loginPage';
  static const String signUp = '/signUpPage';
  static const String forgotPassword = '/forgotPasswordPage';
  static const String listTeacher = '/listTeacherPage';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      signUp: (context) => const SignUpPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      listTeacher: (context) => const ListTeacherPage(),
    };
  }
}

