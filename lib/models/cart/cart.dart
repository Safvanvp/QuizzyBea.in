import 'package:flutter/material.dart';
import 'package:quizzybea_in/assets/product_images.dart';
import 'package:quizzybea_in/models/product/product_model.dart';

class Cart extends ChangeNotifier {
  //list of item for sale
  List<Product> toyList = [
    Product(
      name: 'Count Dino',
      price: 119,
      imagepath: ProductImages.product1,
      description: 'VTech Chomp ',
    ),
    Product(
      name: 'Music player',
      price: 99,
      imagepath: ProductImages.product2,
      description: 'Music Toys',
    ),
    Product(
      name: 'GEARS Building Set',
      price: 199,
      imagepath: ProductImages.product3,
      description: 'Discovery Toys',
    ),
    Product(
      name: 'Play Cube',
      price: 149,
      imagepath: ProductImages.product4,
      description: 'Hape Country Critters',
    ),
    Product(
      name: 'Number blocks',
      price: 49,
      imagepath: ProductImages.product5,
      description: 'Hape Country Critters',
    ),
    Product(
      name: 'Wooden block ',
      price: 99,
      imagepath: ProductImages.product6,
      description: 'Hape Country Critters',
    ),
  ];

  //list of items in user cart
  List<Product> userCart = [];

  //get list of items for sale
  List<Product> getToyList() {
    return toyList;
  }

  //get cart
  List<Product> getCart() {
    return userCart;
  }

  //calculate total
  double calculateTotal() {
    double total = 0;
    for (var item in userCart) {
      total += item.price;
    }
    return total;
  }

  //add item to cart
  void addToCart(Product product) {
    userCart.add(product);
    notifyListeners();
  }

  //remove item from cart
  void removeFromCart(Product product) {
    userCart.remove(product);
    notifyListeners();
  }

  //clear cart
  void clearCart() {
    userCart.clear();
    notifyListeners();
  }
}
