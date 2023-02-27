import 'package:flutter/material.dart';
import 'package:hardik_2048/utils/colorUtils.dart';

import 'button_widget.dart';
import 'score_board_widget.dart';

class GameActionableWidget extends StatefulWidget {
  final VoidCallback onUndoPressed;
  final VoidCallback onNewGamePressed;
  final String score;
  final bool isGameOver;

  const GameActionableWidget(
      {Key? key,
      required this.onUndoPressed,
      required this.onNewGamePressed,
      required this.score,
      required this.isGameOver})
      : super(key: key);

  @override
  State<GameActionableWidget> createState() => _GameActionableWidgetState();
}

class _GameActionableWidgetState extends State<GameActionableWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
          icon: Icons.undo,
          onPressed: () {
            //Undo the round.
            widget.onUndoPressed();
          },
          backgroundColor: scoreBackground,
        ),
        const SizedBox(width: 18),
        Score(label: 'Score', score: widget.score),
        const SizedBox(width: 18),
        ButtonWidget(
          icon: Icons.refresh,
          onPressed: () {
            //Restart the game
            widget.onNewGamePressed();
          },
          backgroundColor: widget.isGameOver ? hintButtonBackground : scoreBackground
        )
      ],
    );
  }
}
