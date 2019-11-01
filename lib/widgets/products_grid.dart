import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';

import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavourites;

  ProductsGrid(
    this.showOnlyFavourites,
  );

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnlyFavourites ? productsData.favouriteItems : productsData.items;

    return GridView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}
