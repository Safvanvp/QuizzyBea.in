import 'package:flutter/material.dart';
import 'package:quizzybea_in/screens/shop/cart.dart';
import 'package:quizzybea_in/screens/shop/shop.dart';

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
    const Cart(),
  ];

  

  void navigateBottomNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userName = _userData?['name'] ?? 'User';

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
