import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import '../widgets/go_to_cart_button.dart';

import '../providers/products.dart';

enum FilterOptions {
  All,
  Favourites,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  var _showAll = true;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.All) {
                  _showAll = true;
                  _showOnlyFavourites = false;
                }
                if (selectedValue == FilterOptions.Favourites) {
                  _showAll = false;
                  _showOnlyFavourites = true;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('All Products'),
                    _showAll
                        ? Icon(
                            Icons.done,
                            color: Colors.green,
                          )
                        : Container(),
                  ],
                ),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Favourites'),
                    _showOnlyFavourites
                        ? Icon(
                            Icons.done,
                            color: Colors.green,
                          )
                        : Container(),
                  ],
                ),
                value: FilterOptions.Favourites,
              ),
            ],
          ),
          GoToCartButton(),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourites),
    );
  }
}
