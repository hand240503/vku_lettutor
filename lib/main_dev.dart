import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/firebase_options.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/list_teacher_page/list_teacher_page.dart';
import 'package:lettutor/pages/login_page/login_page.dart';
import 'package:lettutor/pages/sign-up_page/sign-up_page.dart';
import 'package:lettutor/providers/auth_provider.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:lettutor/providers/tutor_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => TutorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/listTeacherPage',
      routes: {
        '/loginPage': (context) => const LoginPage(),
        '/signupPage': (context) => const SignUpPage(),
        '/listTeacherPage': (context) => const ListTeacherPage(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Provider.of<SettingsProvider>(context).locale,
    );
  }
}
