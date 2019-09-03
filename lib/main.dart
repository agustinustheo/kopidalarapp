import 'package:flutter/material.dart';
import 'package:kopidalar/pages/splash/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi Dalar',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: SplashPage(),
    );
  }
}