import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './product.dart';

class Products with ChangeNotifier {
  final String userId;

  Products(this.userId, this._items);

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser
        ? Firestore.instance
            .collection('products')
            .where('creatorId', isEqualTo: userId)
            .getDocuments()
        : Firestore.instance.collection('products').getDocuments();
    try {
      QuerySnapshot prodSnap = await filterString;

      if (prodSnap == null) {
        return;
      }

      DocumentSnapshot favSnap = await Firestore.instance
          .collection('userFavourites')
          .document(userId)
          .get();

      List<Product> loadedProducts = [];

      prodSnap.documents.forEach(
        (product) async {
          loadedProducts.add(
            Product(
              id: product.documentID,
              title: product['title'],
              price: product['price'],
              image: product['image'],
              description: product['description'],
              isFavourite: favSnap.data == null
                  ? false
                  : favSnap.data[product.documentID] ?? false,
            ),
          );
        },
      );

      _items = loadedProducts;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final docRef = await Firestore.instance.collection('products').add({
        'title': product.title,
        'image': product.image,
        'price': product.price,
        'description': product.description,
        'creatorId': userId,
      });
      final newProduct = Product(
        id: docRef.documentID,
        title: product.title,
        image: product.image,
        price: product.price,
        description: product.description,
      );

      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    try {
      final index = _items.indexWhere((product) => product.id == id);
      if (index >= 0) {
        await Firestore.instance
            .collection('products')
            .document(id)
            .updateData({
          'title': updatedProduct.title,
          'description': updatedProduct.description,
          'image': updatedProduct.image,
          'price': updatedProduct.price,
        });
        _items[index] = updatedProduct;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    try {
      _items.removeAt(existingProductIndex);

      await Firestore.instance.collection('products').document(id).delete();

      existingProduct = null;

      notifyListeners();
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    }
  }
}
