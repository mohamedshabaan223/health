import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_state.dart';

class DoctorImageProfile extends StatelessWidget {
  const DoctorImageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCubit = BlocProvider.of<UserProfileCubit>(context);
    return Stack(
      children: [
        BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            print("Building UI with Image: ${profileCubit.profilePhotoPath}");
            return CircleAvatar(
              radius: 60,
              backgroundImage: profileCubit.profilePhotoPath != null &&
                      profileCubit.profilePhotoPath!.isNotEmpty
                  ? FileImage(File(profileCubit.profilePhotoPath!))
                  : const AssetImage('assets/images/Mask group.png')
                      as ImageProvider,
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () async => await profileCubit.pickImage(),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: AppTheme.green,
                border: Border.all(width: 2, color: AppTheme.white),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 20, color: AppTheme.white),
            ),
          ),
        )
      ],
    );
  }
}
