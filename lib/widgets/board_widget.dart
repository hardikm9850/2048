import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hardik_2048/widgets/tiles_widget.dart';

import '../model/boardcell.dart';
import '../utils/colorUtils.dart';

class GameBoardWidget extends StatefulWidget {
  final List<List<BoardCell>> tiles;

  const GameBoardWidget({Key? key, required this.tiles}) : super(key: key);

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  late MediaQueryData queryData;
  final double sideMargin = 16 * 2;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double size = _getBoardSize() - sideMargin;
    final sizePerTile = (size / 5).floorToDouble();
    double marginBetweenTiles = sizePerTile / 5;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0), color: boardBackground),
      child: SizedBox(
        child: Stack(children: [
          GridWidget(sizePerTile, marginBetweenTiles, widget.tiles),
        ]),
      ),
    );
  }

  double _getBoardSize() {
    var minimumSide = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final size = max(300.0, min(minimumSide, 400.0));
    return size;
  }
}
