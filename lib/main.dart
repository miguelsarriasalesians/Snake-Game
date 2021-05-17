import 'package:flutter/material.dart';
import 'package:mucho_invader/screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: MainScreen(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}
