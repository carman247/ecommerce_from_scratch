import 'package:ecommerce_from_scratch/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      print(result);
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
      print(result);
      
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
