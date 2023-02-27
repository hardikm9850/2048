import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

import '../controller/game_controller.dart';
import '../widgets/board_widget.dart';
import '../widgets/celebration_widget.dart';
import '../widgets/game_actionable_widget.dart';
import '../widgets/game_over_widget.dart';
import '../widgets/score_board_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _gameController;
  late ConfettiController _animationController;
  var lastKeyStrokeTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _gameController = GameController();
    _animationController =
        ConfettiController(duration: const Duration(seconds: 10));
    _gameController.init();
  }

  @override
  Widget build(BuildContext context) {
    var commentWidgets = <Widget>[];
    if (_gameController.isGameWon()) {
      commentWidgets
          .add(CelebrationWidget(animationController: _animationController));
      _animationController.play();
    } else {
      commentWidgets.clear();
    }

    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          handleKeyEvent(event);
        },
        child: Column(
          children: [
            Expanded(
                child: SwipeDetector(
              onSwipe: (direction, offset) {
                setState(() {
                  onSwipedDetected(direction);
                });
              },
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      ScoreBoardWidget(
                          highestScore: _gameController.getHighScore(),
                          key: null),
                      const SizedBox(
                        height: 20,
                      ),
                      GameBoardWidget(
                        tiles: _gameController.getBoardCells(),
                      ),
                      const SizedBox(height: 20),
                      GameActionableWidget(
                        onUndoPressed: () {
                          setState(() {
                            _animationController.stop();
                            _gameController.undo();
                          });
                        },
                        onNewGamePressed: () {
                          setState(() {
                            _animationController.stop();
                            _gameController.reset();
                          });
                        },
                        score: _gameController.getScore(),
                        isGameOver: _gameController.isGameOver(),
                      ),
                    ],
                  ),
                  GameOverWidget(
                      shouldShow: _gameController.isGameOver(),
                      callback: () {
                        setState(() {
                          _gameController.reset();
                        });
                      }),
                  ...commentWidgets
                ],
              ),
            ))
          ],
        ));
  }

  void onSwipedDetected(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.up:
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

  void handleKeyEvent(RawKeyEvent event) {
    var currentKeyStrokeTime = DateTime.now().millisecondsSinceEpoch;
    if(currentKeyStrokeTime - lastKeyStrokeTime < 5) {
      lastKeyStrokeTime = currentKeyStrokeTime;
      return;
    }
    lastKeyStrokeTime = currentKeyStrokeTime;
    SwipeDirection? direction;
    if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)){
      direction = SwipeDirection.up;
    } else if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)){
      direction = SwipeDirection.down;
    } else if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
      direction = SwipeDirection.left;
    } else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)){
      direction = SwipeDirection.right;
    }
    if(direction != null) {
      setState(() {
        onSwipedDetected(direction!);
      });
    }
  }
}
