import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final Function(String) onChanged;
  final bool readOnly;
  final Future<Null> Function() onTap;
  final int lines;
  const TextInputWidget({
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.onChanged = defaultOnChanged,
    this.readOnly = false,
    this.onTap = defaultOnTap,
    this.lines = 1,
    super.key,
  });

  static Future<Null> defaultOnTap() async {}

  static void defaultOnChanged(String value) {}

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        fillColor: Color.fromARGB(255, 193, 219, 179),
        filled: true,
        labelStyle: TextStyle(color: Color.fromARGB(255, 255, 251, 238)),
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
      ),
      style: TextStyle(color: Color.fromARGB(255, 255, 159, 178)),
      obscureText: isPassword,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: lines,
    );
  }
}
