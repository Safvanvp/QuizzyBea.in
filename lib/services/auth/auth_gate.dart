import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzybea_in/screens/home/home.dart';
import 'package:quizzybea_in/screens/intriductions/introdution.dart';
import 'package:quizzybea_in/screens/splash/splash.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //loading screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Splash();
          }
          //user is logged in
          if (snapshot.hasData) {
            return HomePage();
          }

          //user is not logged in

          else {
            return Introduction();
          }
        },
      ),
    );
  }
}
