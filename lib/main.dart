import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quizzybea_in/core/app_router.dart';
import 'package:quizzybea_in/firebase_options.dart';
import 'package:quizzybea_in/theme/app_theme.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep the native splash visible while we initialize
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Lock to portrait mode for a consistent quiz experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Done initializing — remove native splash
  FlutterNativeSplash.remove();

  runApp(const QuizzyBeaApp());
}

class QuizzyBeaApp extends StatelessWidget {
  const QuizzyBeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'QuizzyBea',
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
