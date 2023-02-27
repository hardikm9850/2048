import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CelebrationWidget extends StatelessWidget {
  final ConfettiController animationController;

  const CelebrationWidget({Key? key, required this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: animationController,
          blastDirection: pi / 2,
          maxBlastForce: 5,
          minBlastForce: 1,
          emissionFrequency: 0.03,
          numberOfParticles: 10,
          // particles will pop-up
          gravity: 0.4,
        ));
  }
}
