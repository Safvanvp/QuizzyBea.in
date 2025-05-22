import 'package:flutter/material.dart';
import 'package:quizzybea_in/screens/shop/cart_page.dart';
import 'package:quizzybea_in/screens/shop/shop_page.dart';

import 'package:quizzybea_in/widgets/components/my_bottom_nav.dart';
import 'package:quizzybea_in/widgets/components/my_drawer.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _userData;

  final List<Widget> _pages = [
    const Shop(),
    const CartPage(),
  ];

  void navigateBottomNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: MyDrawer(userData: _userData), // ✅ Send userData to drawer
      bottomNavigationBar: MyBottomNav(
        onTabChange: navigateBottomNav,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting message

          // Page content
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
