import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mucho_invader/widgets/my_button.dart';
import 'package:mucho_invader/widgets/my_pixel.dart';

enum Direction { left, right, up, down, none }

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int numberOfSquares = 460;
  int tickDuration = 500;
  List<int> piece = [];
  List<int> landed = [];
  Direction currentDirection = Direction.left;
  Direction nextDirection = Direction.none;

  void startGame() {
    piece = [numberOfSquares - 230];
    updateNextDirection(Direction.none);
    Timer.periodic(Duration(milliseconds: tickDuration), (timer) {
      //Set direction
      // if (piece.first % 20 == 0) {
      //   nextDirection = Direction.right;
      // } else if (piece.last % 20 == 19) {
      //   nextDirection = Direction.left;
      // }
      //Transformar currentDirection a partir de la nextDirection
      if (nextDirection == Direction.right) {
        switch (currentDirection) {
          case Direction.none:
            break;
          case Direction.right:
            currentDirection = Direction.down;
            break;
          case Direction.left:
            currentDirection = Direction.up;

            break;
          case Direction.up:
            currentDirection = Direction.right;

            break;
          case Direction.down:
            currentDirection = Direction.left;

            break;
        }
      }

      if (nextDirection == Direction.left) {
        switch (currentDirection) {
          case Direction.none:
            break;
          case Direction.right:
            currentDirection = Direction.up;
            break;
          case Direction.left:
            currentDirection = Direction.down;

            break;
          case Direction.up:
            currentDirection = Direction.left;

            break;
          case Direction.down:
            currentDirection = Direction.right;

            break;
        }
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
            piece[i] -= 20;
          }
        }
        if (currentDirection == Direction.down) {
          for (int i = 0; i < piece.length; i++) {
            piece[i] += 20;
          }
        }
      });
      updateNextDirection(Direction.none);
    });
  }

  void stack() {}

  @override
  void initState() {
    nextDirection = Direction.none;
    super.initState();

    startGame();
  }

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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20),
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
                      icon: Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      function: () {
                        updateNextDirection(Direction.left);
                      },
                      text: "L E F T",
                    ),
                    MyButton(
                      function: () {
                        updateNextDirection(Direction.right);
                      },
                      icon: Center(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      text: "R I G H T",
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

  updateNextDirection(Direction direction) {
    setState(() {
      nextDirection = direction;
    });
  }
}
