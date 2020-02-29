import 'package:flutter/material.dart';
import 'package:grad_project/providers/auth_provider.dart';
import 'screens/landing.dart';
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
      ],
      child: MaterialApp(
        home: Landing(),
      ),
    );
  }
}
