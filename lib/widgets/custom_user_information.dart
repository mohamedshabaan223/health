import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class CustomUserInformation extends StatelessWidget {
  const CustomUserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          child: Image.asset('assets/images/Mask group.png'),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, WelcomeBack', style: TextStyle(color: AppTheme.green)),
            Text(
              'John Doe',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: AppTheme.green2),
            ),
          ],
        ),
      ],
    );
  }
}
