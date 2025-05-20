import 'package:flutter/material.dart';
import 'package:quizzybea_in/assets/images.dart';
import 'package:quizzybea_in/theme/colors.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          width: 150,
          child: Image.asset(AppImages.logo),
        ),
      ),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _categoryCard(
                    title: categories[index]["title"]!,
                    backgroundImage: categories[index]["background"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard({
    required String title,
    required String backgroundImage,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.star_rate_rounded,
                size: 40,
                color: Colors.yellow,
                shadows: [
                  Shadow(
                    color: Colors.yellow,
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  'Start Now',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darckbg,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
