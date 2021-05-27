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
  int tickDuration = 250;
  List<int> piece = [];
  List<int> food = [];
  List<int> walls = [];
  bool gameOver = false;
  int totalMilliseconds = 0;
  int numberSquaresPerLine = 20;

  List<int> landed = [];
  Direction currentDirection = Direction.left;
  Direction nextDirection = Direction.none;

  void startGame() {
    generateWalls();
    gameOver = false;
    piece = [numberOfSquares - 185, numberOfSquares - 186, numberOfSquares - 187];

    food = [
      numberOfSquares - 299,
      numberOfSquares - 111,
      numberOfSquares - 333,
      numberOfSquares - 234,
      numberOfSquares - 66
    ];
    updateNextDirection(Direction.none);
    Timer.periodic(Duration(milliseconds: tickDuration), (timer) {
      totalMilliseconds += tickDuration;
      if (checkSameValuePixels() && totalMilliseconds > 1000) {
        print("GAME OVER");
      }
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

      setState(() {
        if (currentDirection == Direction.left) {
          bodyFollow();
          piece[0] -= 1;
        }
        if (currentDirection == Direction.right) {
          bodyFollow();
          piece[0] += 1;
        }
        if (currentDirection == Direction.up) {
          bodyFollow();
          piece[0] -= 20;
        }
        if (currentDirection == Direction.down) {
          bodyFollow();
          piece[0] += 20;
        }
      });
      updateNextDirection(Direction.none);
    });
  }

  void stack() {}
  void bodyFollow() {
    for (int i = piece.length - 1; i > 0; i--) {
      piece[i] = piece[i - 1];
    }
  }

  @override
  void initState() {
    nextDirection = Direction.none;
    super.initState();

    startGame();
  }

  int counter = 0;

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
                  // if (piece[0] == index) {
                  //   currentPixel.color = Colors.yellow;
                  // }
                } else if (food.contains(index)) {
                  currentPixel.color = Colors.red;
                } else if (walls.contains(index)) {
                  currentPixel.color = Colors.brown[900];
                } else {
                  currentPixel.color = Colors.black;
                }

                // if (checkSameValuePixels()) {
                //   print("GAME OVER $counter");
                //   counter++;
                // }

                if (piece.contains(index) && walls.contains(index)) {
                  gameOver = true;
                }

                if (piece.contains(index) && food.contains(index)) {
                  switch (currentDirection) {
                    case Direction.none:
                      break;
                    case Direction.left:
                      piece.add(piece[piece.length - 1] + 1);

                      break;
                    case Direction.right:
                      piece.add(piece[piece.length - 1] - 1);

                      break;
                    case Direction.up:
                      piece.add(piece[piece.length - 1] + 20);

                      break;
                    case Direction.down:
                      piece.add(piece[piece.length - 1] - 20);

                      break;
                  }
                  food.remove(index);
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

  bool checkSameValuePixels() {
    bool result = false;
    List<int> list = [];

    for (int i = 0; i < piece.length; i++) {
      if (list.contains(piece[i])) {
        result = true;
      }
      list.add(piece[i]);
    }
    return result;
  }

  void generateWalls() {
    //Muro superior
    for (int i = 0; i < numberSquaresPerLine; i++) {
      walls.add(i);
    }
    //Muro inferior
    int lastLineSecondPixel = numberOfSquares - (numberSquaresPerLine - 1);
    for (int i = lastLineSecondPixel; i < lastLineSecondPixel + numberSquaresPerLine - 2; i++) {
      walls.add(i);
    }
    //Muro derecha
    for (int i = 19; i < numberOfSquares; i += 20) {
      walls.add(i);
    }
    //Muro izquierda
    for (int i = 20; i < numberOfSquares; i += 20) {
      walls.add(i);
    }
  }
}
