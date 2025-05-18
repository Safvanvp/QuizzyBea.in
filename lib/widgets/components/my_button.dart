import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                shadowColor: Colors.black38,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onPressed: onTap,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 22,
                ),
              )),
        ));
  }
}
