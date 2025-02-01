import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app/app_theme.dart';

class DoctorsAndFavourite extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onTap;

  const DoctorsAndFavourite({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // يمكنك تخصيص اللون هنا
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            FaIcon(
              icon,
              size: 22,
              color: AppTheme.green,
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.green,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
