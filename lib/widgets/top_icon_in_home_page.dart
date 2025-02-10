import 'package:flutter/material.dart';

class TopIconInHomePage extends StatelessWidget {
  const TopIconInHomePage({
    super.key,
    required this.icons,
    required this.containerBackgroundColor,
    required this.onPressed,
  });
  final Icon icons;
  final Color containerBackgroundColor;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      width: 37,
      decoration: BoxDecoration(
          color: containerBackgroundColor,
          borderRadius: BorderRadius.circular(30)),
      child: IconButton(onPressed: onPressed, icon: icons),
    );
  }
}
