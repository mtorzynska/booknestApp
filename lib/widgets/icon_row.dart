import 'package:flutter/material.dart';

class IconRowWidget extends StatelessWidget {
  final Icon icons;
  final double iconSize;
  final Color middleIconColor;
  final Color leftToMiddleColor;
  final Color borderIconColor;
  final MainAxisAlignment alignment;

  const IconRowWidget({
    super.key,
    required this.icons,
    this.iconSize = 24.0,
    this.middleIconColor = Colors.black,
    this.leftToMiddleColor = Colors.white,
    this.borderIconColor = Colors.green,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: alignment, children: [
      Icon(
        Icons.circle,
        size: iconSize,
        color: borderIconColor,
      ),
      const SizedBox(
        width: 5,
      ),
      Icon(
        Icons.circle,
        size: iconSize,
        color: leftToMiddleColor,
      ),
      const SizedBox(
        width: 5,
      ),
      Icon(
        Icons.circle,
        size: iconSize,
        color: middleIconColor,
      ),
      const SizedBox(
        width: 5,
      ),
      Icon(
        Icons.circle,
        size: iconSize,
        color: leftToMiddleColor,
      ),
      const SizedBox(
        width: 5,
      ),
      Icon(
        Icons.circle,
        size: iconSize,
        color: borderIconColor,
      )
    ]);
  }
}
