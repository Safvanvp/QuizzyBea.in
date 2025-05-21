import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzybea_in/assets/images.dart';
import 'package:quizzybea_in/screens/quizz_screen.dart/quizz_screen.dart';
import 'package:quizzybea_in/services/auth/auth_gate.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/theme/colors.dart';
import 'package:quizzybea_in/widgets/components/my_card.dart';
import 'package:quizzybea_in/widgets/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthServices _authServices = AuthServices();

  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authServices.getCurrentUser();
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userData = snapshot.data();
      });
    }
  }

  final List<Map<String, String>> categories = [
    {"title": "General Knowledge", "background": AppImages.cardBg1},
    {"title": "Music & Poetry", "background": AppImages.cardBg2},
    {"title": "Geopolitics", "background": AppImages.cardBg3},
    {"title": "Astro science", "background": AppImages.cardBg4},
    {"title": "Chemistry", "background": AppImages.cardBg5},
    {"title": "History", "background": AppImages.cardBg6},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          width: 150,
          child: Image.asset(AppImages.logo),
        ),
        iconTheme: IconThemeData(
          color: AppColors.darckbg,
        ),
      ),
      drawer: MyDrawer(
        userData: _userData,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.darckbg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_userData != null)
                        Text(
                          'Hi,',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      if (_userData != null)
                        Text(
                          _userData!['name'] ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                  Container(
                    width: 2,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Icon(Icons.person, color: AppColors.white, size: 50),
                ],
              ),
            ),
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darckbg,
              ),
            ),
            const Divider(thickness: 2, color: Colors.black),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return MyCard(
                    title: categories[index]["title"]!,
                    backgroundImage: categories[index]["background"]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => QuizzScreen(
                            quizzcategory: categories[index]["title"]!,
                          ),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
