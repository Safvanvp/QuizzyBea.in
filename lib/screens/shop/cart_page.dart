import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzybea_in/models/cart/cart.dart';
import 'package:quizzybea_in/models/product/product_model.dart';
import 'package:quizzybea_in/widgets/components/my_cart_tile.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
        builder: (context, cart, child) => SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(
    padding: const EdgeInsets.all(16),
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Total Amount
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '₹${cart.calculateTotal().toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        // Checkout Button
        ElevatedButton(
          onPressed: () {
            // TODO: implement your checkout logic here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Checkout pressed!")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[400],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Checkout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  ),
),

                  const SizedBox(
                    height: 20,
                  ),
                  //cart items
                  Expanded(
                      child: ListView.builder(
                    itemCount: cart.getCart().length,
                    itemBuilder: (context, index) {
                      //get individual item
                      Product individualItem = cart.getCart()[index];

                      //return the cart item
                      return MyCartTile(product: individualItem);
                    },
                  ))
                ],
              ),
            ));
  }
}
