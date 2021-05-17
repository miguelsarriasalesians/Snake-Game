import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  Function function;

  MyButton({this.text = "P L A Y", this.textColor = Colors.white, this.fontSize = 30, this.function});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          print(this.text);
          function();
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                    child: Text(
                  this.text,
                  style: TextStyle(
                    color: this.textColor,
                    fontSize: this.fontSize,
                  ),
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
