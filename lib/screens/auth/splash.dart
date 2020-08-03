import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/Logo.png'),
            Image.asset('assets/Talentya.png'),
          ],
        ),
//        child: FlutterLogo(
//          size: 128,
//        ),
      ),
    );
  }
}
