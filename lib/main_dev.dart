import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/common/loading_overlay.dart';
import 'package:lettutor/firebase_options.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/list_teacher_page/list_teacher_page.dart';
import 'package:lettutor/pages/login_page/login_page.dart';
import 'package:lettutor/providers/auth_provider.dart';
import 'package:lettutor/providers/courses_provider.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:lettutor/providers/tutor_provider.dart';
import 'package:lettutor/router/app_routes.dart';
import 'package:lettutor/utilities/const.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TutorProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
                          ? LoadingOverlay(child: ListTeacherPage())
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
