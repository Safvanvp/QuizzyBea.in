import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNav extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNav({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GNav(
          color: Colors.grey[400],
          activeColor: Colors.grey.shade700,
          tabActiveBorder: Border.all(color: Colors.grey, width: 1),
          tabBackgroundColor: Colors.white,
          tabBorderRadius: 16,
          backgroundColor: Colors.transparent,
          onTabChange: (value) => onTabChange!(value),
          mainAxisAlignment: MainAxisAlignment.center,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'H O M E',
              iconColor: Colors.white,
            ),
            GButton(
              icon: Icons.shopping_cart,
              text: 'C A R T',
              iconColor: Colors.white,
            ),
          ]),
    );
  }
}
