import 'package:flutter/material.dart';
import 'package:hardik_2048/widgets/tiles.dart';

import '../utils/constants.dart';

class BoardWidget extends StatefulWidget {
  final double tileSize;
  final double margin;

  const BoardWidget({Key? key, required this.tileSize, required this.margin})
      : super(key: key);

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  late MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return AspectRatio(
        aspectRatio: 1,
        child: Container(
          width: _getSize(),
          height: _getSize(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: boxBackground,
          ),
          child: SizedBox(
            child: Stack(children: [
              Tiles(widget.tileSize, widget.margin),
            ]),
          ),
        )
    );
  }

  double _getSize() {
    double width = queryData.size.width;
    double height = queryData.size.height;
    if (width > height) {
      //web
      return height - 200;
    }
    return width;
  }
}
