import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    required this.rating,
    this.maxRtaing = 5,
    this.size = 26,
    this.color = AppTheme.green,
    this.emptyColor = Colors.grey,
  });
  final int maxRtaing;
  final int rating;
  final double size;
  final Color color;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxRtaing, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: size,
          color: index < rating ? color : emptyColor,
        );
      }),
    );
  }
}
