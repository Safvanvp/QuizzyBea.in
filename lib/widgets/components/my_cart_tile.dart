import 'package:flutter/material.dart';
import 'package:quizzybea_in/models/product/product_model.dart';

class MyCartTile extends StatefulWidget {
  Product product;
  MyCartTile({super.key, required this.product});

  @override
  State<MyCartTile> createState() => _MyCartTileState();
}

class _MyCartTileState extends State<MyCartTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
      ),
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: const Offset(2, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(widget.product.imagepath),
        title: Text(widget.product.name),
        subtitle: Text(widget.product.description),
        trailing: Text(widget.product.price.toString()),
      ),
    );
  }
}
