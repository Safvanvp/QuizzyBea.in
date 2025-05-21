import 'package:flutter/material.dart';
import 'package:quizzybea_in/services/auth/auth_gate.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/theme/colors.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final AuthServices _authServices = AuthServices();

  void _logout(BuildContext context) async {
    _authServices.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthGate()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary,
      child: Column(
        children: [
          const DrawerHeader(
              child: Column(
            children: [
              Icon(Icons.account_circle, size: 100, color: AppColors.darckbg),
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: const Icon(Icons.home, color: AppColors.darckbg),
              title: const Text(
                'Home',
                style: TextStyle(color: AppColors.darckbg),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: const Icon(Icons.settings, color: AppColors.darckbg),
              title: const Text(
                'Settings',
                style: TextStyle(color: AppColors.darckbg),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: const Icon(Icons.info, color: AppColors.darckbg),
              title: const Text(
                'About',
                style: TextStyle(color: AppColors.darckbg),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          Spacer(),

          //logout button
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 25),
            child: ListTile(
              leading: Icon(Icons.logout, color: AppColors.darckbg),
              title: Text(
                'LOGOUT',
                style: TextStyle(color: AppColors.darckbg),
              ),
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
