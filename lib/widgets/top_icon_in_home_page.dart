import 'package:flutter/material.dart';

class TopIconInHomePage extends StatelessWidget {
  const TopIconInHomePage({
    super.key,
    required this.icons,
    required this.containerBackgroundColor,
  });
  final Icon icons;
  final Color containerBackgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      width: 37,
      decoration: BoxDecoration(
          color: containerBackgroundColor,
          borderRadius: BorderRadius.circular(30)),
      child: IconButton(onPressed: () {}, icon: icons),
    );
  }
}
