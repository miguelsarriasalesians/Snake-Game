import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mucho_invader/screens/main_screen.dart';
import 'package:mucho_invader/widgets/my_button.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "M  E  N  U",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              MyButton(
                text: "P  L  A  Y",
                function: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
              MyButton(
                text: "E  X  I  T",
                function: () {
                  exit(0);
                },
              )
            ],
          ),
        ));
  }
}
