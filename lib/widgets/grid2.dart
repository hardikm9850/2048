import 'package:flutter/cupertino.dart';

import '../utils/constants.dart';

class Grid extends StatelessWidget {

  double gridSize = 0.0;
  int rows = 4;
  int columns = 4;

  Grid({super.key, required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: createList(),
    );
  }

  List<Widget> createList() {
    List<Widget> list = [];
    for (int i = 0; i < rows; i++) {
      List<Widget> gridList = [];
      for (int j = 0; j < columns; j++) {
        gridList.add(EmptyGrid(size: gridSize));
      }
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: gridList,
      ));
    }
    return list;
  }
}

var emptyDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(6.0),
  color: gridColor,
);

class EmptyGrid extends StatelessWidget {
  final double size;

  const EmptyGrid({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: emptyDecoration,
    );
  }
}
