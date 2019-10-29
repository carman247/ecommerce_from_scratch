import 'package:ecommerce_from_scratch/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

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

  //create user object based on FirebaseUser
  Future<User> _userFromFirebaseUser(FirebaseUser user) async {
    await user.getIdToken().then((token) {
      // print('[T O K E N  S T A R T] $token');
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
      // print(result);

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
}
