import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Classes/User.dart';

enum Status { Uninitialized, Unauthenticated, Authenticated }

class Authenticator extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  Firestore _firestore = Firestore.instance;
  Status _status = Status.Uninitialized;

  Status get getStatus => _status;

  Authenticator() {
    checkPreviousLogin();
  }

  checkPreviousLogin() async {
    print('Fetching prefs instance');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Getting stored email and password');
    String email = prefs.get('email');
    String pass = prefs.get('password');

    if (email == null || pass == null) {
      print('No saved data found');
      _status = Status.Unauthenticated;
    } else {
      print('Logging in with saved credentials');
      _logIn(email.trim(), pass);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  logIn(String email, String pass, bool savePass) async {
    try {
      await _logIn(email.trim(), pass);
      if (savePass) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email.trim());
        await prefs.setString('password', pass);
      }
      _status = Status.Authenticated;
      notifyListeners();
    } catch (e) {
      return e.message;
    }
  }

  signUp(String email, String pass, String confirmPass, String username) async {
    if (pass != confirmPass) {
      return "Passwords do not match";
    }
    if (username.isEmpty) {
      return "Username can not be empty";
    }
    try {
      var signUpResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      var user = User(
        id: signUpResult.user.uid,
        bio: '',
        name: username,
        followingCount: 0,
        followerCount: 0,
        postCount: 0,
        profilePictureUrl: '',
      );
      await _firestore
          .collection('users')
          .document(signUpResult.user.uid)
          .setData(user.toJson());

      _status = Status.Authenticated;
      notifyListeners();
      return "Signed up successfully";
    } catch (e) {
      return e.message;
    }
  }

  _logIn(String email, String pass) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
    _user = await _firebaseAuth.currentUser();
  }
}
