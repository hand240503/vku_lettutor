import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/firebase_options.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/providers/auth_provider.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:lettutor/providers/tutor_provider.dart';
import 'package:lettutor/router/app_routes.dart';
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
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Provider.of<SettingsProvider>(context).locale,
    );
  }
}
