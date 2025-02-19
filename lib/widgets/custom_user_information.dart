import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_state.dart';

class CustomUserInformation extends StatelessWidget {
  const CustomUserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileSuccess) {
          print(
              "Data Loaded: ${state.userProfile.name}, ${state.userProfile.photoData}");
        }
      },
      builder: (context, state) {
        String userName = "Guest";
        String? photoPath;

        if (state is UserProfileSuccess) {
          userName = state.userProfile.name;
          photoPath = state.userProfile.photoData;
        }

        return Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: photoPath != null
                  ? (photoPath.startsWith('http')
                      ? NetworkImage(photoPath) as ImageProvider
                      : (photoPath.startsWith('data:image')
                          ? MemoryImage(
                              base64Decode(photoPath.split(',').last),
                            ) as ImageProvider
                          : FileImage(File(photoPath))))
                  : const AssetImage('assets/images/Mask group.png'),
            ),
            SizedBox(width: width * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hi, Welcome Back',
                  style: TextStyle(
                      color: AppTheme.green,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '" $userName "',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: AppTheme.green),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
