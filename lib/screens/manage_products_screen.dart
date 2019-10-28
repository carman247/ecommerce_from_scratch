import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

import '../screens/edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = ('/manage-products');

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                UserProductItem(
                  id: products.items[index].id,
                  image: products.items[index].image,
                  title: products.items[index].title,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
