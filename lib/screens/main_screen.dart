import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mucho_invader/widgets/my_button.dart';
import 'package:mucho_invader/widgets/my_pixel.dart';

enum Direction {
  left,
  right,
  up,
  down,
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int numberOfSquares = 120;
  int tickDuration = 250;
  List<int> piece = [];
  List<int> landed = [];
  Direction currentDirection = Direction.left;

  void startGame() {
    piece = [numberOfSquares - 3, numberOfSquares - 2, numberOfSquares - 1];
    Timer.periodic(Duration(milliseconds: tickDuration), (timer) {
      //Set direction
      if (piece.first % 10 == 0) {
        currentDirection = Direction.right;
      } else if (piece.last % 10 == 9) {
        currentDirection = Direction.left;
      }
      // else if (piece.any((element) {
      //   element < 9 && element >= 0;
      // })) {
      //   currentDirection == Direction.down;
      // } else if (piece.any((element) {
      //   element < 119 && element >= 110;
      // })) {
      //   currentDirection == Direction.up;
      // }

      setState(() {
        if (currentDirection == Direction.left) {
          for (int i = 0; i < piece.length; i++) {
            piece[i] -= 1;
          }
        }
        if (currentDirection == Direction.right) {
          for (int i = 0; i < piece.length; i++) {
            piece[i] += 1;
          }
        }
        if (currentDirection == Direction.up) {
          for (int i = 0; i < piece.length; i++) {
            piece[i] -= 10;
          }
        }
        if (currentDirection == Direction.down) {
          for (int i = 0; i < piece.length; i++) {
            piece[i] += 10;
          }
        }
      });
    });
  }

  void stack() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GridView.builder(
              itemCount: numberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
              itemBuilder: (context, index) {
                MyPixel currentPixel = MyPixel();
                if (piece.contains(index)) {
                  currentPixel.color = Colors.white;
                } else {
                  currentPixel.color = Colors.black;
                }
                return currentPixel;
              },
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      function: startGame,
                      text: "P L A Y",
                    ),
                    MyButton(
                      function: stack,
                      text: "S T O P",
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
