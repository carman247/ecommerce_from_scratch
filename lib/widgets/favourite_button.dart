import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      // Consumer is essentially the same as calling Provider.of except it only reloads a subpart of the widget tree. Calling listen false on product stops the page from rebuilding.
      builder: (ctx, product, child) => IconButton(
        //child is a place holder for widgets that you do not want to rebuild
        // e.g. Text(child). However, it's not used in this example.
        icon: Icon(
          product.isFavourite ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
          product.toggleFavouriteStatus();
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
