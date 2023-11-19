import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hardik_2048/controller/game_controller.dart';

import '../utils/colorUtils.dart';

class ScoreBoardWidget extends StatelessWidget {
  final gameController = Get.find<GameController>();

  ScoreBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Score(
                label: 'Best',
                score: gameController.highScore.value.toString(),
              ),
              Score(
                label: 'Moves',
                score: gameController.numberOfMoves.value.toString(),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Score(
            label: 'Timer',
            score: formatTimer(gameController.timer.value),
          ),
        ],
      ),
    );
  }
}

class Score extends StatelessWidget {
  const Score(
      {Key? key, required this.label, required this.score, this.padding})
      : super(key: key);

  final String label;
  final String score;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: scoreBackground, borderRadius: BorderRadius.circular(8.0)),
      child: Column(children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 18.0, color: Color(0xFFEEE4DA)),
        ),
        Text(
          score,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
        )
      ]),
    );
  }
}


String formatTimer(String input) {
  int seconds = int.parse(input);

  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = remainingSeconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}

