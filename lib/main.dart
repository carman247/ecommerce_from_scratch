import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/cart_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/auth-screen.dart';
import './screens/edit_product_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/edit_profile_screen.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          initialBuilder: null,
          builder: (ctx, auth, previousProductsState) => Products(
            auth.userId,
            previousProductsState == null ? [] : previousProductsState.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          initialBuilder: null,
          builder: (ctx, auth, previousCartState) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          initialBuilder: null,
          builder: (ctx, auth, previousOrdersState) => Orders(
            auth.userId,
            previousOrdersState == null ? [] : previousOrdersState.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ecommerce Template',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.redAccent,
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder:
                      (BuildContext ctx, AsyncSnapshot authResultSnapshot) {
                    switch (authResultSnapshot.connectionState) {
                      case ConnectionState.none:
                        return SplashScreen();
                      case ConnectionState.waiting:
                        return SplashScreen();
                      case ConnectionState.active:
                        return SplashScreen();
                      case ConnectionState.done:
                        return AuthScreen();
                    }
                    return null;
                  },
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
          },
        ),
      ),
    );
  }
}
