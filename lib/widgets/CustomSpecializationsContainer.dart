import 'package:flutter/material.dart';
import 'dart:io';

class SpecializationContainer extends StatelessWidget {
  final String title;
  final String imagePath;
  final void Function()? onTap;

  const SpecializationContainer({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF67C897), Color(0xFF0B7043)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imagePath.isNotEmpty && File(imagePath).existsSync()
                  ? Image.file(
                      File(imagePath),
                      height: 40,
                      width: 40,
                    )
                  : Image.asset(
                      'assets/images/rheumatology_46dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.png',
                      height: 40,
                      width: 40,
                    ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
