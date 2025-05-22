import 'package:flutter/material.dart';
import 'package:quizzybea_in/models/product/product_model.dart';

class MyProductTile extends StatelessWidget {
  Product product;
  void Function()? onTap;
  MyProductTile({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
      ),
      width: 280,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: []),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //product image
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.imagepath,
                height: 250,
                fit: BoxFit.cover,
              )),

          const SizedBox(
            height: 10,
          ),

          //product description
          Text(product.description,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),

          const SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //product name
                  Container(
                    width: 200,
                    child: Text(product.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  //product price + details
                  Text('\$${product.price.toString()}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              //add to cart
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 35),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
