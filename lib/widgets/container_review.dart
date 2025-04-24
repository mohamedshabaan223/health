import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/get_all_review_model.dart';

class ContainerReview extends StatelessWidget {
  final ReviewModel review;
  const ContainerReview({super.key, required this.review});

  List<Widget> _buildStars(int rating) {
    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        stars.add(const Icon(
          Icons.star,
          color: AppTheme.green,
          size: 20,
        ));
      } else {
        stars.add(const Icon(
          Icons.star_border,
          color: AppTheme.green,
          size: 20,
        ));
      }
    }

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 244, 246, 253),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage('assets/images/male.png'),
            backgroundColor: AppTheme.green.withOpacity(0.2),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.senderName ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppTheme.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '(${review.age ?? "N/A"} years)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: _buildStars(review.rating),
                ),
                const SizedBox(height: 10),
                Text(
                  review.comment ?? 'No comment available.',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
