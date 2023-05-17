import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hardik_2048/widgets/tiles_widget.dart';

import '../model/boardcell.dart';
import '../utils/colorUtils.dart';

class GameBoardWidget extends StatelessWidget {
  RxList<RxList<Rx<BoardCell>>> tiles;

  GameBoardWidget({Key? key, required this.tiles}) : super(key: key);

  late MediaQueryData queryData;
  final double sideMargin = 16 * 2;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double size = _getBoardSize(context) - sideMargin;
    final sizePerTile = (size / 5).floorToDouble();
    double marginBetweenTiles = sizePerTile / 5;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0), color: boardBackground),
      child: SizedBox(
        child: Stack(children: [
          GridWidget(sizePerTile, marginBetweenTiles, tiles)
        ]),
      ),
    );
  }

  double _getBoardSize(BuildContext context) {
    var minimumSide = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final size = max(300.0, min(minimumSide, 400.0));
    return size;
  }
}

class GridWidget1 extends StatelessWidget {
  final double tileSize;
  final double margin;
  final RxList<RxList<Rx<BoardCell>>> tiles;

  const GridWidget1(this.tileSize, this.margin, this.tiles, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: createList(
        tileSize,
        margin,
      ),
    ));
  }

  List<Widget> createList(double tileSize, double margin) {
    List<Widget> list = [];

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        var cell = tiles[i][j].value;

        list.add(CellWidget(
            left: cell.row,
            top: cell.column,
            size: tileSize,
            margin: margin,
            text: cell.number));
      }
    }

    return list;
  }
}

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
