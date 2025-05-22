import 'package:flutter/material.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = AuthServices().getCurrentUser();
    if (user != null) {
      final doc = await AuthServices()
          .firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _userData = doc.data();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = _userData?['name'] ?? 'User';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //greeting message
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Hi $userName,\nWelcome to the merch shop!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        //serch bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
          ),
        )
      ],
    );
  }
}
