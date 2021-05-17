import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  Color color;
  MyPixel({this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Container(
          color: this.color,
        ),
      ),
    );
  }
}
