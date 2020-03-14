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
      try {
        print(1);
        print('Logging in with saved credentials');
        print(2);
        await _logIn(email.trim(), pass);
        print(3);
        _status = Status.Authenticated;
        print(4);
      } catch (e) {
        print(5);
        print('An error occured while loggin with saved credentials');
        print(6);
        _status = Status.Unauthenticated;
        print(7);
      }
    }
    notifyListeners();
  }

  logIn(String email, String pass, bool savePass) async {
    try {
      print('x');
      await _logIn(email.trim(), pass);
      print('y');
      if (savePass) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email.trim());
        await prefs.setString('password', pass);
      }
      print('z');

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
        profilePictureUrl: 'https://firebasestorage.googleapis.com/v0/b/talentapp-dc5b9.appspot.com/o/avatars%2Fprofile%20stock.png?alt=media&token=eb14f30b-1bc5-4074-ad5d-2d9f7ae4536e',
        coverPictureUrl: 'https://firebasestorage.googleapis.com/v0/b/talentapp-dc5b9.appspot.com/o/avatars%2Fcover.jpg?alt=media&token=4bf040ac-3137-4312-a93f-08553746896c',
      );
      await _firestore
          .collection('users')
          .document(signUpResult.user.uid)
          .setData(user.toJson());

      //_status = Status.Authenticated;
      //notifyListeners();
      await _firebaseAuth.signOut();
      return "Signed up successfully";
    } catch (e) {
      return e.message;
    }
  }

  _logIn(String email, String pass) async {
    print('a');

    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );

    print('b');
    _user = await _firebaseAuth.currentUser();
  }
}
