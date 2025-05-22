import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzybea_in/firebase_options.dart';
import 'package:quizzybea_in/models/cart/cart.dart';
import 'package:quizzybea_in/services/auth/auth_gate.dart';

import 'package:quizzybea_in/theme/colors.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      builder: (context, child)=>MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzy Beea.in',
      theme: ThemeData(scaffoldBackgroundColor: AppColors.primary),
      home: AuthGate(),
    ),
    );
  }
}
