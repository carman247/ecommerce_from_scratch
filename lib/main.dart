import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart.screen.dart';
import './screens/manage_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/auth-screen.dart';
import './screens/edit_product_screen.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.orange,
          ),
          home: AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          }),
    );
  }
}
