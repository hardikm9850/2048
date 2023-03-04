import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controller/game_controller.dart';
import '../widgets/board_widget.dart';
import '../widgets/celebration_widget.dart';
import '../widgets/game_actionable_widget.dart';
import '../widgets/game_over_widget.dart';
import '../widgets/score_board_widget.dart';

class GameScreen extends GetView<GameController> {
  late ConfettiController _animationController;
  int lastKeyStrokeTime = 0;

  GameScreen({Key? key}) : super(key: key) {
    _animationController =
        ConfettiController(duration: const Duration(seconds: 10));
    lastKeyStrokeTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    var commentWidgets = <Widget>[];
    if (controller.isGameWon.value == true) {
      print("is Game over? ${controller.isGameWon.value}");
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
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Obx(() => ScoreBoardWidget(
                          highestScore: controller.highScore.value.toString(),
                          key: null)),
                      const SizedBox(
                        height: 20,
                      ),
                      SwipeDetector(
                          onSwipe: (direction, offset) {
                            onSwipedDetected(direction);
                          },
                          child: GameBoardWidget(
                            tiles: controller.reactiveBoardCells,
                          )),
                      const SizedBox(height: 20),
                      Obx(() => (GameActionableWidget(
                            onUndoPressed: () {
                              _animationController.stop();
                              controller.undo();
                            },
                            onNewGamePressed: () {
                              _animationController.stop();
                              controller.reset();
                            },
                            score: controller.score.value,
                            isGameOver: controller.isGameOver.value,
                          ))),
                    ],
                  ),
                  Obx(() => GameOverWidget(
                      shouldShow: controller.isGameOver.value,
                      callback: () {
                        controller.reset();
                      })),
                  ...commentWidgets
                ],
              ),
            )
          ],
        ));
  }

  void onSwipedDetected(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.up:
        controller.moveUp();
        break;
      case SwipeDirection.down:
        controller.moveDown();
        break;
      case SwipeDirection.left:
        controller.moveLeft();
        break;
      case SwipeDirection.right:
        controller.moveRight();
        break;
    }
  }

  void handleKeyEvent(RawKeyEvent event) {
    var currentKeyStrokeTime = DateTime.now().millisecondsSinceEpoch;
    if (currentKeyStrokeTime - lastKeyStrokeTime < 5) {
      lastKeyStrokeTime = currentKeyStrokeTime;
      return;
    }
    lastKeyStrokeTime = currentKeyStrokeTime;
    SwipeDirection? direction;
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      direction = SwipeDirection.up;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      direction = SwipeDirection.down;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      direction = SwipeDirection.left;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      direction = SwipeDirection.right;
    }
    if (direction != null) {
      onSwipedDetected(direction!);
    }
  }
}
