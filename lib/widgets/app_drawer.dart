import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_from_scratch/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/manage_products_screen.dart';
import '../screens/orders_screen.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  final String userId;

  AppDrawer(this.userId);

  _buildUsername(BuildContext context, DocumentSnapshot document) {
    return Text(document['displayName']);
  }

  _buildEmail(BuildContext context, DocumentSnapshot document) {
    return Text(document['email']);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Shop Name'),
          ),
          UserAccountsDrawerHeader(
            accountName: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document('$userId')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...");
                return _buildUsername(context, snapshot.data);
              },
            ),
            accountEmail: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document('$userId')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...");
                return _buildEmail(context, snapshot.data);
              },
            ),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              // await Provider.of<Products>(context, listen: false)
              //     .fetchAndSetProducts(true);
              Navigator.of(context)
                  .pushReplacementNamed(ManageProductsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(EditProfileScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
