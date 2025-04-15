import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/profile_cubit/profile_state.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/pages/patient_profile_page.dart';
import 'package:health_app/widgets/container_icon.dart';
import 'package:health_app/widgets/update_text_field.dart';

class PatientUpdateProfile extends StatelessWidget {
  static const String id = "/update_profile";

  const PatientUpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    final profileCubit = BlocProvider.of<UserProfileCubit>(context);
    int userId = CacheHelper().getData(key: 'id');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppTheme.green),
                    ),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                          color: AppTheme.green,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    ContainerIcon(
                      onTap: () => Navigator.of(context)
                          .pushNamed(PatientUpdateProfile.id),
                      iconName: Icons.settings,
                      containerColor: AppTheme.green,
                      iconColor: AppTheme.white,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      BlocBuilder<UserProfileCubit, UserProfileState>(
                        builder: (context, state) {
                          print(
                              "Building UI with Image: ${profileCubit.profilePhotoPath}");
                          return CircleAvatar(
                            radius: 52,
                            backgroundImage: profileCubit.profilePhotoPath !=
                                        null &&
                                    profileCubit.profilePhotoPath!.isNotEmpty
                                ? FileImage(
                                    File(profileCubit.profilePhotoPath!))
                                : const AssetImage(
                                        'assets/images/Mask group.png')
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
                              border:
                                  Border.all(width: 2, color: AppTheme.white),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                size: 20, color: AppTheme.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildProfileField(
                    context, 'Full Name', profileCubit.nameController),
                _buildProfileField(
                    context, 'Phone number', profileCubit.phoneController),
                _buildProfileField(
                    context, 'Email', profileCubit.emailController),
                _buildProfileField(
                    context, 'Password', profileCubit.passwordController,
                    isPassword: true),
                SizedBox(height: height * 0.06),
                _buildUpdateButton(context, profileCubit, userId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
      BuildContext context, String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          UpdateTextField(
            hintText:
                controller.text.isNotEmpty ? controller.text : 'Enter $label',
            controller: controller,
            isPassword: isPassword,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(
      BuildContext context, UserProfileCubit profileCubit, int userId) {
    return BlocListener<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Profile updated successfully!"),
                backgroundColor: AppTheme.green2),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ProfilePatient()),
            (route) => false,
          );
        } else if (state is UpdateProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Failed to update profile: ${state.errorMessage}"),
                backgroundColor: Colors.red),
          );
        }
      },
      child: Center(
        child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            return InkWell(
              onTap: () => profileCubit.updateProfile(userId),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 220,
                decoration: BoxDecoration(
                  color: AppTheme.green,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ],
                ),
                child: state is UpdateProfileLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Update Profile',
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
