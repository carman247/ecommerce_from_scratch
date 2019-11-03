import 'package:ecommerce_from_scratch/widgets/image_carousel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import '../widgets/go_to_cart_button.dart';

import '../providers/products.dart';
import '../providers/auth.dart';

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
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
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
      drawer: AppDrawer(Provider.of<Auth>(context).userId),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ImageCarousel(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Popular Products',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ProductsGrid(_showOnlyFavourites),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Categories',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
