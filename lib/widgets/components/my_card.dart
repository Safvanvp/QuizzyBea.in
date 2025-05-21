import 'package:flutter/material.dart';
import 'package:quizzybea_in/theme/colors.dart';

class MyCard extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final VoidCallback onTap;
  MyCard({
    required this.title,
    required this.backgroundImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: TextButton(
                    onPressed: onTap,
                    child: Text(
                      'Start Now',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darckbg,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
