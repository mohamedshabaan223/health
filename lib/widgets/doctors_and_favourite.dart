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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              width: 160,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 22,
                  color: AppTheme.green,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.green,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
