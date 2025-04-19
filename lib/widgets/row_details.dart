import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class RowDetails extends StatelessWidget {
  const RowDetails({super.key, required this.label, required this.details});
  final String label;
  final String details;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.black,
            ),
          ),
          Text(
            details,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.green2,
            ),
          ),
        ],
      ),
    );
  }
}
