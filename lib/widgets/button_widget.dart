import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final double fontSize;

  const ButtonWidget({
    required this.onPressed,
    required this.text,
    this.backgroundColor = const Color.fromARGB(255, 255, 159, 178),
    this.foregroundColor = const Color.fromARGB(255, 255, 246, 220),
    this.elevation = 0,
    this.fontSize = 15,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(elevation),
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(foregroundColor),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
