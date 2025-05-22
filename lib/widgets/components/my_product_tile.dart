import 'package:flutter/material.dart';
import 'package:quizzybea_in/models/product/product_model.dart';

class MyProductTile extends StatelessWidget {
  Product product;
  MyProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      width: 280,
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          //product image
          //product description
          //product price + details
          //add to cart
        ],
      ),
    );
  }
}
