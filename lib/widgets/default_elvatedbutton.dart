import 'package:flutter/material.dart';

class DefaultElvatedbutton extends StatelessWidget {
  DefaultElvatedbutton({required this.label, required this.onPressed});
  String label;
  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 21),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 15),
      ),
    );
  }
}
