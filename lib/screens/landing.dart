import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_navigation/main_navigation.dart';
import 'auth/log_in.dart';
import 'auth/sign_up.dart';
import 'auth/splash.dart';
import '../providers/auth_provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var authProvider = Provider.of<Authenticator>(context);
    print('REDRAWING LANDING PAGE');
    return Builder(
      builder: (context){
        switch(authProvider.getStatus) {
          case Status.Uninitialized:
            return Splash();
          case Status.Unauthenticated:
            return LogIn();
          case Status.Authenticated:
            return MainNavigationPage();
          default:
            return Center(
              child: Text('law enta shayef de fe 7aga 8alat'),
            );
        }
      },
    );
  }
}
