import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

import '../widgets/add_to_cart_button.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
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
              leading: ToggleFavButton(authData: authData),
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

class ToggleFavButton extends StatelessWidget {
  ToggleFavButton({
    @required this.authData,
  });

  final Auth authData;

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (ctx, product, child) => IconButton(
        icon: Icon(
          product.isFavourite ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
          product.toggleFavouriteStatus(
            prodId: product.id,
            userId: authData.userId,
          );
          product.isFavourite
              ? Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added item to favourites.'),
                    duration: Duration(seconds: 3),
                  ),
                )
              : Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed item from favourites.'),
                    duration: Duration(seconds: 3),
                  ),
                );
        },
      ),
    );
  }
}
