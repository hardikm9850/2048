import 'package:flutter/material.dart';
import '../utils/colorUtils.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key, this.text, this.icon,required this.backgroundColor, required this.onPressed});

  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      //Button Widget with icon for Undo and Restart Game button.
      return Container(
          width: 70,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
        child: IconButton(
            color: const Color(0xfff9f6f2),
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 24.0,
            ))
      );
    }
    //Button Widget with text for New Game and Try Again button.
    return ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(16.0)),
            backgroundColor: MaterialStateProperty.all<Color>(color256)),
        onPressed: onPressed,
        child: Text(
          text!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ));
  }
}
