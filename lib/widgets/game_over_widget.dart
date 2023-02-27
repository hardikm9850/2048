import 'package:flutter/material.dart';

class GameOverWidget extends StatefulWidget {
  bool shouldShow;
  final VoidCallback callback;
  GameOverWidget({Key? key, required this.shouldShow, required this.callback}) : super(key: key);

  @override
  State<GameOverWidget> createState() => _GameOverWidgetState();
}

class _GameOverWidgetState extends State<GameOverWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        width: widget.shouldShow ? MediaQuery.of(context).size.width : 0,
        height: widget.shouldShow ? MediaQuery.of(context).size.height : 0,
        top: widget.shouldShow ? 0.0 : 0,
        left: widget.shouldShow ? 0.0 : 0,
        duration: widget.shouldShow
            ? const Duration(seconds: 3)
            : const Duration(seconds: 0),
        curve: Curves.elasticOut,
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.shouldShow = false;
            });
          },
          child: Container(
            color: Colors.black38,
            child: widget.shouldShow
                ? const Center(
                    child: Text(
                    'Game Over\n\n\nNew game?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white),
                  ))
                : const SizedBox(),
          ),
        ));
  }
}
