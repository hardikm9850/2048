import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

import '../controller/gamecontrol.dart';
import '../utils/constants.dart';
import '../widgets/board_widget.dart';
//1, 3, => 2,  3, 3, => 2,
class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  late GameController _gameController;

  @override
  void initState() {
    super.initState();
    _gameController = GameController();
    _gameController.init();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double boardSize = queryData.size.width - 20.0 * 2;
    var tileSize = (boardSize - 8.0) / 5;
    var margin = (boardSize / 5) / 5;

    return Column(
      children: [
        Expanded(
            child: Container(
              child: SwipeDetector(
                onSwipe: (direction,offset){
                  setState(() {
                    onSwipedDetected(direction);
                  });
                },
                child: Column(
                  children: [
                    Container(
                        margin:
                        const EdgeInsets.symmetric(vertical: 20.0, horizontal: 22),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: boardBackground,
                              ),
                              child: BoardWidget(
                                tiles: _gameController.boardCells,
                                tileSize: tileSize,
                                margin: margin,
                              ),
                            )
                        )
                    ),
                    Text("Score : ${_gameController.score}"),
                    ElevatedButton(onPressed:(){
                      setState(() {
                        _gameController.reset();
                      });
                    } , child: const Text("Reset"))
                  ],
                ),
              ),
            ))
      ],
    );
  }

  void onSwipedDetected(SwipeDirection direction) {
    print("swipe ${direction.name}");
    switch(direction){
      case SwipeDirection.up :
        _gameController.moveUp();
        break;
      case SwipeDirection.down:
        _gameController.moveDown();
        break;
      case SwipeDirection.left:
        _gameController.moveLeft();
        break;
      case SwipeDirection.right:
        _gameController.moveRight();
        break;
    }
  }
}
