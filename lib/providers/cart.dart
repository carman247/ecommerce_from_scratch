import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int total = 0;

    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return _items == null ? 0 : total.round();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  getCartTotal(String userId) async {
    var cartTotal = 0;
    try {
      QuerySnapshot snapshot = await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('cart')
          .getDocuments();
      if (snapshot == null) {
        return;
      }
      snapshot.documents.forEach((doc) {
        if (doc == null) {
          return;
        }
        cartTotal = cartTotal + doc.data['quantity'];
      });
    } catch (error) {
      print(error);
    }
    print(cartTotal);
  }

  Future<void> clearCart() {
    _items = {};
    notifyListeners();
    return null;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void undoAddItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeSingleItem(String id) {
    // This will eventually remove all items from the cart once their total reaches 0.
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
      Fluttertoast.showToast(msg: 'Item removed from cart');
    }
    notifyListeners();
    // This will stop removing items from the cart once they reach zero. Currently means people can order 0 x items...
    ////////////////////////////////////////////////////////////////////
    // _items.update(
    //   id,
    //   (existingCartItem) => existingCartItem.quantity >= 1
    //       ? CartItem(
    //           id: existingCartItem.id,
    //           title: existingCartItem.title,
    //           price: existingCartItem.price,
    //           quantity: existingCartItem.quantity - 1,
    //         )
    //       : CartItem(
    //           id: existingCartItem.id,
    //           title: existingCartItem.title,
    //           price: existingCartItem.price,
    //           quantity: existingCartItem.quantity,
    //         ),
    // );
    ////////////////////////////////////////////////////////////////////
  }

  void addSingleItem(String id) async {
    _items.update(
      id,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
      ),
    );

    notifyListeners();
  }

  void addItem(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
