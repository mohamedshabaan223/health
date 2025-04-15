import 'package:flutter/material.dart';

class DoctorImageProfile extends StatelessWidget {
  const DoctorImageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundImage: AssetImage('assets/images/doctor_image.png'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: Color(0xFF58CFA4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
