import 'package:flutter/material.dart';
import 'package:hardik_2048/widgets/tiles.dart';

import '../utils/constants.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late double tileSize;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double boardSize = queryData.size.width - 4.0 * 2;
    tileSize = (boardSize - 8.0) / 5;
    var margin = (boardSize / 5) / 5;

    return Column(
      children: [
        Expanded(
            child: Container(
          color: screenBackground,
          child: Column(
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: boxBackground,
                        ),
                        child: SizedBox(
                          width: _getSize(),
                          height: _getSize(),
                          child: Stack(children: [
                            Tiles(tileSize, margin),
                          ]),
                        ),
                      )))
            ],
          ),
        ))
      ],
    );
  }

  double _getSize() {
    MediaQueryData queryData = MediaQuery.of(context);
    double width = queryData.size.width;
    double height = queryData.size.height;
    if (width > height) {
      //web
      return height - 200;
    }
    return width;
  }
}
