import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle authScreenTitle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 26,
  );

  static TextStyle appBarTitle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  static TextStyle addScreenSectionTitle = TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle postScreenPostTitle = TextStyle(
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static TextStyle postScreenPostNumbers = TextStyle(
    color: Color.fromRGBO(110, 110, 100, 1),
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static TextStyle postScreenTag = TextStyle(
    color: Color.fromRGBO(0, 0, 255, 1),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle postScreenDescription = TextStyle(
    fontSize: 18,
  );

  static TextStyle postScreenSectionTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static TextStyle homeHeading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black.withOpacity(0.7),
  );
}
