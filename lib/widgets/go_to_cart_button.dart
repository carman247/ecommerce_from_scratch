import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../screens/cart.screen.dart';
import '../widgets/badge.dart';

class GoToCartButton extends StatelessWidget {
  const GoToCartButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (ctx, cartData, child) => Badge(
        // child is what the Badge should be placed on. In this case an IconButton.
        child: IconButton(
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
          icon: Icon(Icons.shopping_cart),
        ),
        value: cartData.itemCount.toStringAsFixed(0),
      ),
    );
  }
}
