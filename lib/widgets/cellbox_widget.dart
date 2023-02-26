import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CellBox extends StatelessWidget {
  final double left;
  final double top;
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
    var horizontalMargin = margin * (left +1) ;
    var verticalMargin = margin * (top +1) ;
    return Positioned(
      top: verticalMargin + top * size,
      left: horizontalMargin + left * size,
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: gridColor,
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
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
