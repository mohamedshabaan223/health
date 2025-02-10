import 'package:flutter/material.dart';

class ContainerIcon extends StatelessWidget {
  const ContainerIcon({
    required this.iconName,
    required this.containerColor,
    required this.iconColor,
    required this.onTap,
  });
  final IconData iconName;
  final Color containerColor;
  final Color iconColor;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            color: containerColor, borderRadius: BorderRadius.circular(30)),
        child: Icon(
          iconName,
          size: 22,
          color: iconColor,
        ),
      ),
    );
  }
}
