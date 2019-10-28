import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  // var _showFavouritesOnly = false;

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return items.where((product) => product.isFavourite).toList();
    // }

    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  List<Product> get availableItems {
    return _items.where((product) => product.isAvailable).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final List<Product> loadedProducts = [];
      QuerySnapshot snapshot =
          await Firestore.instance.collection('products').getDocuments();
      if (snapshot == null) {
        return;
      }
      snapshot.documents.forEach(
        (doc) => loadedProducts.add(
          Product(
            id: doc.documentID,
            title: doc.data['title'],
            description: doc.data['description'],
            price: doc.data['price'],
            image: doc.data['image'],
            isFavourite: doc.data['isFavourite'],
          ),
        ),
      );
      _items = loadedProducts.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final docRef = await Firestore.instance.collection('products').add({
        'title': product.title,
        'image': product.image,
        'price': product.price,
        'description': product.description,
        'isFavourite': false,
      });
      final newProduct = Product(
        id: docRef.documentID,
        title: product.title,
        image: product.image,
        price: product.price,
        description: product.description,
        isFavourite: false,
      );
      print(newProduct.id);
      _items.insert(0,
          newProduct); // <- this adds to the beginning of the created list. // _items.add(newProduct); will add to the end of the created list..
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
