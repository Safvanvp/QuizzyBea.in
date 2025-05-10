import 'package:flutter/material.dart';
import 'package:quizzybea_in/screens/splash/splash.dart';
import 'package:quizzybea_in/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzy Beea.in',
      theme: ThemeData(scaffoldBackgroundColor: AppColors.primary),
      home: const Splash(),
    );
  }
}
