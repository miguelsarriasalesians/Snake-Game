import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
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
  int numberOfSquares = 420;
  int tickDuration = 500;
  int score = 0;
  List<int> piece = [];
  List<int> food = [];
  List<int> walls = [];
  bool gameOver = false;
  int totalMilliseconds = 0;
  int numberSquaresPerLine = 20;
  Timer timer;

  List<int> landed = [];
  Direction currentDirection = Direction.left;
  Direction nextDirection = Direction.none;

  void _restartApp() async {
    FlutterRestart.restartApp();
  }

  void startGame() {
    score = 0;
    food = [];
    generateWalls();
    generateFood();
    gameOver = false;
    piece = [numberOfSquares - 185, numberOfSquares - 186];

    updateNextDirection(Direction.none);
    timer = Timer.periodic(Duration(milliseconds: tickDuration), (timer) {
      totalMilliseconds += tickDuration;
      generateFood();
      if (checkSameValuePixels() && totalMilliseconds > 1000) {
        print("GAME OVER");
        piece = [numberOfSquares - 185, numberOfSquares - 186];
        currentDirection = Direction.left;
        updateNextDirection(Direction.none);
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "SCORE:  ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Text(
                            score.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          timer.cancel();
                          _restartApp();
                          // exit(0);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.height * 0.05,
                          color: Colors.red,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
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
                    restartGame();

                    // Navigator.pop(context);
                    //
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => GameOverScreen()),
                    // );

                    //Navigate towards GameOver Screen
                  }

                  if (piece.contains(index) && food.contains(index)) {
                    switch (currentDirection) {
                      case Direction.none:
                        break;
                      case Direction.left:
                        piece.insert(0, piece[0] - 1);

                        break;
                      case Direction.right:
                        piece.insert(0, piece[0] + 1);

                        break;
                      case Direction.up:
                        piece.insert(0, piece[0] - 20);

                        break;
                      case Direction.down:
                        piece.insert(0, piece[0] + 20);

                        break;
                    }
                    food.remove(index);
                    score += 50;
                    tickDuration = (tickDuration * 0.95).toInt();
                    print(tickDuration.toDouble());
                  }
                  return currentPixel;
                },
              ),
            ),
            Expanded(
              flex: 1,
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

  void generateFood() {
    Random random = Random();
    int randomNum, seed;
    seed = random.nextInt(100);
    do {
      randomNum = random.nextInt(numberOfSquares);
    } while (walls.contains(randomNum) && food.contains(randomNum));

    if (!walls.contains(randomNum) && !food.contains(randomNum) && food.length < 4 && seed < 18) {
      food.add(randomNum);
    }
  }

  void restartGame() {
    gameOver = true;
    piece.clear();
    food.clear();

    piece = [numberOfSquares - 185, numberOfSquares - 186];
    currentDirection = Direction.left;
    score = 0;
  }
}
