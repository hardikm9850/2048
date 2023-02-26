import 'package:flutter/material.dart';

import 'cellbox.dart';

class Tiles extends StatelessWidget {
  final double tileSize;
  final double margin;

  const Tiles(this.tileSize, this.margin, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
     children: createList(tileSize,margin),
    );
  }
}

List<Widget> createList(double tileSize, double margin) {
  List<Widget> list = [];
  for (double i = 0; i < 4; i++) {
    for (double j = 0; j < 4; j++) {
      list.add(CellBox(
          left: i,
          top: j,
          size: tileSize,
          margin: margin,
          text: const Text("")));
    }
  }
  return list;
}
