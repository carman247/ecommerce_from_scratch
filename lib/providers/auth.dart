import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../models/user.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId {
    return _userId;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future<User> _userFromFirebaseUser(FirebaseUser user) async {
    await user.getIdToken().then((token) {
      _token = token.token;
      _expiryDate = token.expirationTime;
      _userId = user.uid;
    });
    notifyListeners();
    return user != null ? User(uid: user.uid) : null;
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      Firestore.instance
          .collection('userFavourites')
          .document(user.uid)
          .setData({});

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // print(result);

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }
}
