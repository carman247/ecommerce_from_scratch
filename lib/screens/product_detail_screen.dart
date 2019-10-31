import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/go_to_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = 'product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

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
    final arguments = ModalRoute.of(
      context,
    ).settings.arguments as Map;
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Products>(context, listen: false)
        .findProductById(arguments['id']);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: <Widget>[
          GoToCartButton(),
        ],
      ),
      body: !_isLoading
          ? ListView(
              children: <Widget>[
                GridTile(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            product.title,
                            style: TextStyle(fontSize: 32),
                          ),
                          Text(
                            product.brand,
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: Text(
                              '£${product.price.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      FavButtonStreamBuilder(
                          authData: authData, product: product)
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 30, right: 30, bottom: 30),
                    child: Text(
                      product.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
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

class FavButtonStreamBuilder extends StatelessWidget {
  const FavButtonStreamBuilder({
    Key key,
    @required this.authData,
    @required this.product,
  }) : super(key: key);

  final Auth authData;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('userFavourites')
          .document(authData.userId)
          .snapshots(),
      builder: (ctx, snapshot) {
        print(snapshot);
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.active:
            return IconButton(
              icon: Icon(
                snapshot.data["${product.id}"] == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                product.toggleFavouriteStatus(
                  userId: authData.userId,
                );
                snapshot.data["${product.id}"] != true
                    ? Fluttertoast.showToast(msg: 'Added to favourites')
                    : Fluttertoast.showToast(msg: 'Removed from favourites');
              },
            );
          case ConnectionState.done:
            return IconButton(
              icon: Icon(
                snapshot.data["${product.id}"] == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                product.toggleFavouriteStatus(
                  userId: authData.userId,
                );
                snapshot.data["${product.id}"] != true
                    ? Fluttertoast.showToast(msg: 'Added to favourites')
                    : Fluttertoast.showToast(msg: 'Removed from favourites');
              },
            );
        }
        return null;
      },
    );
  }
}
