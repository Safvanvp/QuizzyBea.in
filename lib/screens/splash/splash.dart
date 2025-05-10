import 'package:flutter/material.dart';
import 'package:quizzybea_in/assets/images.dart';
import 'package:quizzybea_in/screens/intriductions/introdution.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Image.asset(AppImages.logo),
        ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(milliseconds: 500));

    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Introduction(),
        ),
      );
    }
  }
}
