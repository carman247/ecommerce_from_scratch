import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final bool isPending;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    this.isPending,
  });
}

class Cart with ChangeNotifier {
  // map of productId (String) and CartItem
  Map<String, CartItem> _items = {};
  // copy of the list
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

  void clearCart() {
    _items = {};
    notifyListeners();
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
    _items.update(
      id,
      (existingCartItem) => existingCartItem.quantity >= 1
          ? CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1,
            )
          : CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity,
            ),
    );
    notifyListeners();
  }

  void addSingleItem(String id) {
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

  // add item to cart list
  void addItem(String id, double price, String title
      // (double quantity), (might add function to add more than one at a time later)
      ) {
    // check if item already belongs in the cart
    if (_items.containsKey(id)) {
      // change quantity... key: id, function: (exisitingCartItem) =>, CartItem()
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
      // add new item (key: id, funtcion: =>, value: CartItem())
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
