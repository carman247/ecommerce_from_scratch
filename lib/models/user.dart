import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String uid;
  String userName;
  String userEmail;
  // Map<dynamic, dynamic> userAddress;
  String userPhoneNumber;

  User({
    this.uid,
    this.userName,
    this.userEmail,
    // this.userAddress,
    this.userPhoneNumber,
  });

  String get getUid => uid;
  String get getDisplayName => userName;
  String get getEmail => userEmail;
  // Map<dynamic, dynamic> get getAddress => userAddress;
  String get getContantNumber => userPhoneNumber;

  set setDisplayName(String username) {
    userName = username;
    notifyListeners();
  }

  set setEmail(String email) {
    userEmail = email;
    notifyListeners();
  }

  set setUserAddress(Map<dynamic, dynamic> address) {
    // userAddress = address;
    notifyListeners();
  }

  set setPhoneNumber(String phoneNumber) {
    userPhoneNumber = phoneNumber;
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    var data = {
      'userName': userName,
      'userEmail': userEmail,
      // 'userAddress': userAddress,
      'userPhoneNumber': userPhoneNumber,
    };
    return data;
  }
}
