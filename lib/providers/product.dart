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
  bool isAvailable;

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
    this.isAvailable,
  });

  Future<void> toggleFavouriteStatus() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      await Firestore.instance.collection('products').document(id).updateData({
        'isFavourite': isFavourite,
      });
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }

  void toggleAvailableStatus() {
    isAvailable = !isAvailable;
    notifyListeners();
  }
}
