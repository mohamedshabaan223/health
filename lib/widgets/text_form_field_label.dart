import 'package:flutter/material.dart';

class TextFormFieldLabel extends StatelessWidget {
  const TextFormFieldLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
