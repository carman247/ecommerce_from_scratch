import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String category;
  final String size;
  final double price;
  final double salePrice;
  final String image;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    this.category,
    this.size,
    @required this.price,
    this.salePrice,
    @required this.image,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('favourites')
          .document(id)
          .setData({
        'isFavourite': isFavourite,
      });
    } catch (error) {
      _setFavValue(oldStatus);
      notifyListeners();
    }
  }
}
