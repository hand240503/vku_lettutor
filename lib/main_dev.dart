import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/common/bottom_nav_bar.dart';
import 'package:lettutor/common/loading_overlay.dart';
import 'package:lettutor/data/services/noti_service.dart';
import 'package:lettutor/firebase_options.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/login_page/login_page.dart';
import 'package:lettutor/providers/auth_provider.dart';
import 'package:lettutor/providers/courses_provider.dart';
import 'package:lettutor/providers/quiz_provider.dart';
import 'package:lettutor/providers/schedule_provider.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:lettutor/providers/tutor_provider.dart';
import 'package:lettutor/providers/user_provider.dart';
import 'package:lettutor/router/app_routes.dart';
import 'package:lettutor/utilities/const.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Khởi tạo dịch vụ thông báo
  await LocalNotificationService().initialize();

  // Yêu cầu quyền thông báo
  await requestNotificationPermission();
  await requestExactAlarmPermission();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TutorProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider(),),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> requestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.status;
  if (!status.isGranted) {
    PermissionStatus newStatus = await Permission.notification.request();
    if (newStatus.isGranted) {
      print("Notification permission granted!");
    } else {
      print("Notification permission denied!");
    }
  } else {
    print("Notification permission already granted");
  }
}

Future<void> requestExactAlarmPermission() async {
  PermissionStatus status = await Permission.scheduleExactAlarm.status;
  if (!status.isGranted) {
    PermissionStatus newStatus = await Permission.scheduleExactAlarm.request();
    if (newStatus.isGranted) {
      print("Exact alarm permission granted!");
    } else {
      print("Exact alarm permission denied!");
    }
  } else {
    print("Exact alarm permission already granted");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: settingsProvider.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: const Color.fromRGBO(0, 113, 240, 1.0),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: const Color.fromRGBO(0, 113, 240, 1.0),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: settingsProvider.locale,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return LoadingOverlay(
                child: AnimatedSplashScreen(
                  duration: 1000,
                  splash: Image.asset(ImagesPath.logo),
                  nextScreen:
                      authProvider.currentUser != null
                          ? BottomNavBar()
                          : LoadingOverlay(child: LoginPage()),
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.bottomToTop,
                  backgroundColor: Colors.white,
                ),
              );
            },
          ),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
