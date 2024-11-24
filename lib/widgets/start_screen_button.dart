import 'package:flutter/material.dart';

class StartScreenButton extends StatelessWidget {
  const StartScreenButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.buttonBackgroundColor,
      required this.buttonForegroundColor});
  final String label;
  final void Function()? onPressed;
  final Color buttonBackgroundColor;
  final Color buttonForegroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 20),
        backgroundColor: buttonBackgroundColor,
        foregroundColor: buttonForegroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 21),
      ),
    );
  }
}
