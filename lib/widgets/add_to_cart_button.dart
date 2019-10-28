import 'package:flutter/material.dart';

import '../providers/cart.dart';
import '../providers/product.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    Key key,
    @required this.cart,
    @required this.product,
  }) : super(key: key);

  final Cart cart;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.add_shopping_cart,
        color: Theme.of(context).accentColor,
      ),
      onPressed: () {
        Scaffold.of(context).hideCurrentSnackBar();
        cart.addItem(product.id, product.price, product.title);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Added item to cart.'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
                cart.undoAddItem(product.id);
              },
            ),
          ),
        );
      },
    );
  }
}
