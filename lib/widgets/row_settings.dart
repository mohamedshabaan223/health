import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class RowSetting extends StatelessWidget {
  const RowSetting(
      {super.key,
      this.onTap,
      required this.iconName,
      required this.label,
      required this.iconName2});
  final VoidCallback? onTap;
  final IconData iconName;
  final IconData iconName2;
  final String label;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Icon(
              iconName,
              size: 30,
              color: AppTheme.green,
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(
              flex: 3,
            ),
            Icon(
              iconName2,
              size: 35,
              color: AppTheme.green,
            ),
          ],
        ),
      ),
    );
  }
}
