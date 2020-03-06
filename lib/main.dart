import 'package:flutter/material.dart';
import 'providers/auth_provider.dart';
import 'providers/upload_provider.dart';
import 'package:grad_project/screens/landing.dart';
import 'package:grad_project/screens/add/add.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Authenticator>(
          create: (context) => Authenticator(),
        ),
        ChangeNotifierProvider<Uploader>(
          create: (context) => Uploader(),
        ),
      ],
      child: MaterialApp(
        home: Landing(),
        routes: {'/add_post': (context) => Add()},
      ),
    );
  }
}
