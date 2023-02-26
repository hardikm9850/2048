import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CellBox extends StatelessWidget {
  final int left;
  final int top;
  final double size;
  final double margin;
  //final Color color;
  final Text text;

  const CellBox(
      {super.key,
      required this.left,
      required this.top,
      required this.size,
        required this.margin,
      //required this.color,
      required this.text});

  @override
  Widget build(BuildContext context) {
    var horizontalMargin = margin * (left +1) ; // row
    var verticalMargin = margin * (top +1) ; // column

    return Positioned(
      top: horizontalMargin + left * size,
      left: verticalMargin + top * size,
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: gridBackground,
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(child: text))),
    );
  }
}
