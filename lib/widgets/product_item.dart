import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';

import '../providers/cart.dart';
import '../providers/product.dart';

import '../widgets/add_to_cart_button.dart';
import '../widgets/favourite_button.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 2,
        child: GestureDetector(
          onTap: () {
            Scaffold.of(context).hideCurrentSnackBar();
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: GridTile(
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              leading: FavouriteButton(),
              title: Text(
                product.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black45,
              trailing: AddToCartButton(cart: cart, product: product),
            ),
          ),
        ),
      ),
    );
  }
}
