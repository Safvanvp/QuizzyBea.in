import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzybea_in/models/cart/cart.dart';
import 'package:quizzybea_in/models/product/product_model.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/widgets/components/my_product_tile.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
//add to cart function
  void addToCart(Product product) {
    Provider.of<Cart>(context, listen: false).addToCart(product);

    //alert the user, show success message
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Successfully added!.'),
              content: Text('Item added to cart'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK')),
              ],
            ));
  }

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
    return Consumer<Cart>(
        builder: (context, cart, child) => Column(
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
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hot Picks',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text('See All',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                //hot picks
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cart.getToyList().length,
                  itemBuilder: (context, index) {
                    //get a item from the list

                    Product product = cart.getToyList()[index];

                    //return the product
                    //
                    return MyProductTile(
                      product: product,
                      onTap: () => addToCart(product),
                    );
                  },
                )),
                //new arrivals
              ],
            ));
  }
}
