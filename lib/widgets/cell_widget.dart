import 'dart:collection';

import 'package:flutter/material.dart';

import '../utils/colorUtils.dart';

class CellWidget extends StatelessWidget {
  final int left;
  final int top;
  final double size;
  double margin;
  final int text;
  Map<int, Color> mapOfGridColor = HashMap();

  CellWidget(
      {super.key,
      required this.left,
      required this.top,
      required this.size,
      required this.margin,
      required this.text}) {
    mapOfGridColor.addAll(tileColors);
  }

  @override
  Widget build(BuildContext context) {
    var horizontalMargin = margin * (left + 1); // row
    var verticalMargin = margin * (top + 1); // column

    return Positioned(
      top: horizontalMargin + left * size,
      left: verticalMargin + top * size,
      child: Container(
          width: size,
          height: size,
          // game board style
          decoration: BoxDecoration(
            color: gridBackground,
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: mapOfGridColor[text]),
              // individual cell style
              child: Center(
                  child: Text(getText(), style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold))))),
    );
  }

  String getText() {
    return text == 0 ? "" : text.toString();
  }
}
