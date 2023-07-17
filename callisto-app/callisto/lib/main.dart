// main.dart

import 'package:flutter/material.dart';

import 'login_page.dart';

void main() {

  // Set app-wide theme
  ThemeData theme = ThemeData(
    primarySwatch: Colors.red,
  );
  
  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {

  final ThemeData theme;

  const MyApp({
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: LoginPage(), // Start on login page
    );
  }
}