import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/go_to_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final id = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findProductById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: <Widget>[
          GoToCartButton(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Text('£${product.price.toStringAsFixed(2)}'),
                Spacer(),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                product.description,
              ),
            ),
          ),
        ],
      ),
      // Disabled BottomSheet until SnackBar problem is fixed.

      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        width: double.infinity,
        child: MaterialButton(
          textColor: Theme.of(context).primaryTextTheme.title.color,
          color: Theme.of(context).primaryColor,
          child: Text('ADD TO CART'),
          onPressed: () {
            cart.addItem(product.id, product.price, product.title);
            Fluttertoast.showToast(msg: 'Item added to cart');
          },
        ),
      ),
    );
  }
}
