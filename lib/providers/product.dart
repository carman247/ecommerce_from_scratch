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
    @required this.price,
    @required this.image,
    this.isFavourite = false,
    this.salePrice,
    this.category,
    this.size,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus({String userId, String prodId}) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      Firestore.instance
          .collection('userFavourites')
          .document(userId)
          .updateData({prodId: isFavourite});
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }
}
