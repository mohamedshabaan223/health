import 'package:flutter/material.dart';

class CreateIcons extends StatelessWidget {
  const CreateIcons({super.key, this.onTap, required this.logo_image});
  final Function()? onTap;
  final String logo_image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Image.asset("assets/images/circle_icon.png"),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Image.asset(logo_image),
          ),
        ],
      ),
    );
  }
}
