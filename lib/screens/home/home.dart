import 'package:flutter/material.dart';
import 'package:quizzybea_in/assets/images.dart';
import 'package:quizzybea_in/screens/quizz_screen.dart/quizz_screen.dart';
import 'package:quizzybea_in/services/auth/auth_gate.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/theme/colors.dart';
import 'package:quizzybea_in/widgets/components/my_card.dart';
import 'package:quizzybea_in/widgets/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthServices _authServices = AuthServices();

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
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darckbg,
              ),
            ),
            const SizedBox(height: 10),
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
                        MaterialPageRoute(
                          builder: (_) => QuizzScreen(
                            quizzcategory: categories[index]["title"]!,
                          ),
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
