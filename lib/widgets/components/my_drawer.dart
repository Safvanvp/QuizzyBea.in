import 'package:flutter/material.dart';
import 'package:quizzybea_in/screens/history/user_quiz_history.dart';
import 'package:quizzybea_in/screens/home/home.dart';
import 'package:quizzybea_in/screens/settings/settings_page.dart';
import 'package:quizzybea_in/screens/shop/shop_home_page.dart';
import 'package:quizzybea_in/services/auth/auth_gate.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/theme/colors.dart';

class MyDrawer extends StatelessWidget {
  final Map<String, dynamic>? userData;
  MyDrawer({super.key, required this.userData});

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
          DrawerHeader(
              child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: (userData?['photoUrl'] != null &&
                        userData!['photoUrl'].toString().isNotEmpty)
                    ? NetworkImage(userData!['photoUrl'])
                    : null,
                child: (userData?['photoUrl'] == null ||
                        userData!['photoUrl'].toString().isEmpty)
                    ? const Icon(Icons.person,
                        size: 40, color: AppColors.darckbg)
                    : null,
              ),
              Text(
                userData?['name'] ?? 'Loading...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('${userData?['email'] ?? 'Loading...'}'),
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: const Icon(Icons.home, color: AppColors.darckbg),
              title: const Text(
                'H O M E',
                style: TextStyle(color: AppColors.darckbg),
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: const Icon(Icons.settings, color: AppColors.darckbg),
              title: const Text(
                'S E T T I N G S',
                style: TextStyle(color: AppColors.darckbg),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                }));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading:
                  const Icon(Icons.shopping_cart, color: AppColors.darckbg),
              title: const Text(
                'S H O P',
                style: TextStyle(color: AppColors.darckbg),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ShopHomePage();
                }));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: const Icon(Icons.history, color: AppColors.darckbg),
              title: const Text(
                'H I S T O R Y',
                style: TextStyle(color: AppColors.darckbg),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const UserQuizHistoryPage();
                }));
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
