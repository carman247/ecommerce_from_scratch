import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String userId;

  Orders(this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    try {
      final List<OrderItem> loadedOrders = [];
      QuerySnapshot snapshot = await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('orders')
          .orderBy('dateTime')
          .getDocuments();
      if (snapshot == null) {
        return;
      }
      snapshot.documents.forEach(
        (doc) => loadedOrders.insert(
          0,
          OrderItem(
              id: doc.documentID,
              amount: doc.data['amount'],
              dateTime: DateTime.parse(doc.data['dateTime']),
              products: (doc.data['products'] as List<dynamic>)
                  .map(
                    (product) => CartItem(
                      id: product['id'],
                      price: product['price'],
                      quantity: product['quantity'],
                      title: product['title'],
                    ),
                  )
                  .toList()),
        ),
      );
      _orders = loadedOrders.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final docRef = await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('orders')
        .add({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts
          .map((cartItem) => {
                'id': cartItem.id,
                'title': cartItem.title,
                'quantity': cartItem.quantity,
                'price': cartItem.price,
              })
          .toList()
    });
    // insert 0 (index) adds at the beginning of the list created.
    _orders.insert(
      0,
      OrderItem(
        id: docRef.documentID,
        dateTime: timestamp,
        amount: total,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
