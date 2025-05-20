
import 'package:flutter/material.dart';

class MyLoginproviders extends StatelessWidget {
  final String providername;
  final String image;
  const MyLoginproviders({
    required this.providername,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.fromARGB(90, 255, 255, 255),
          border: Border.all(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.zero, child: Image.asset(image, height: 40)),
            SizedBox(width: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 5),
                Text("Sign in", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("With $providername", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
