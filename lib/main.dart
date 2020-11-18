import 'package:drug_delivery/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Click Health',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[900],
        primaryColorDark: Colors.green[900],
        accentColor: Colors.green[700],
        dividerColor: Colors.black54,
        accentIconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
      ),
      themeMode: ThemeMode.system,
      home: SplashPage(),
    );
  }
}