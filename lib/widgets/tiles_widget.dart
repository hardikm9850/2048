import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hardik_2048/model/boardcell.dart';

import 'cell_widget.dart';

class GridWidget extends StatelessWidget {
  final double tileSize;
  final double margin;
  final RxList<RxList<Rx<BoardCell>>> tiles;

  const GridWidget(this.tileSize, this.margin, this.tiles, {super.key});

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
