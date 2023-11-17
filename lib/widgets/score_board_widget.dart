import 'package:flutter/material.dart';

import '../utils/colorUtils.dart';

class ScoreBoardWidget extends StatelessWidget {
  final String highestScore;
  final String numberOfMoves;

  const ScoreBoardWidget({required this.highestScore,required this.numberOfMoves, super.key});

  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Score(
            label: 'Best',
            score: highestScore,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
        Score(
            label: 'Moves',
            score: numberOfMoves,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
      ],
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
      width: 100,
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
