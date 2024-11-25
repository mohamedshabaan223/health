import 'package:flutter/material.dart';

class SpecialtiesItem extends StatelessWidget {
  const SpecialtiesItem({super.key, required this.image, this.onTap});
  final String image;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        image,
      ),
    );
  }
}
