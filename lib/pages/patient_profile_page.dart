import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_state.dart';
import 'package:health_app/pages/change_password.dart';
import 'package:health_app/pages/start_screen.dart';
import 'package:health_app/pages/patient_update_profile_page.dart';
import 'package:health_app/widgets/row_profile.dart';
import 'package:health_app/widgets/show_delete_account.dart';
import 'package:health_app/widgets/show_logout.dart';

class ProfilePatient extends StatefulWidget {
  static const String id = "/profile_patient";

  const ProfilePatient({super.key});

  @override
  State<ProfilePatient> createState() => _ProfilePatientState();
}

class _ProfilePatientState extends State<ProfilePatient> {
  int? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int storedUserId = CacheHelper().getData(key: 'id');
      if (storedUserId == null) {
        Navigator.of(context).pushReplacementNamed(StartScreen.id);
      } else {
        setState(() {
          userId = storedUserId;
        });
        context.read<UserProfileCubit>().fetchUserProfile(userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    final profileCubit = BlocProvider.of<UserProfileCubit>(context);
    final authCubit = context.read<AuthCubit>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account deleted successfully")),
          );
          CacheHelper().clearAllData();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(StartScreen.id, (route) => false);
        } else if (state is DeleteAccountFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Failed to delete account: ${state.errorMessage}")),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserProfileFailure) {
                return Center(child: Text("Error: ${state.error}"));
              } else if (state is UserProfileSuccess) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 25,
                              color: AppTheme.green,
                            ),
                          ),
                          const Spacer(flex: 2),
                          const Text(
                            'Profile',
                            style: TextStyle(
                                color: AppTheme.green,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(flex: 3),
                        ],
                      ),
                    ),
                    Center(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image(
                              image: profileCubit.profilePhotoPath != null &&
                                      profileCubit.profilePhotoPath!.isNotEmpty
                                  ? FileImage(
                                      File(profileCubit.profilePhotoPath!))
                                  : const AssetImage(
                                          'assets/images/Mask group.png')
                                      as ImageProvider,
                              width: 104,
                              height: 104,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(PatientUpdateProfile.id);
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: AppTheme.green,
                                  border: Border.all(
                                      width: 2, color: AppTheme.white),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      state.userProfile.name,
                      style: const TextStyle(
                        color: AppTheme.green,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: height * 0.06),
                    RowProfile(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(PatientUpdateProfile.id);
                      },
                      label: 'Update Profile',
                      containerColor: AppTheme.gray,
                      iconColor: AppTheme.green,
                      iconName: Icons.person_outline,
                    ),
                    SizedBox(height: height * 0.02),
                    RowProfile(
                      onTap: () {
                        Navigator.of(context).pushNamed(ChangePassword.id);
                      },
                      label: 'Password Manager',
                      containerColor: AppTheme.gray,
                      iconColor: AppTheme.green,
                      iconName: Icons.settings,
                    ),
                    SizedBox(height: height * 0.02),
                    RowProfile(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => const ShowDeleteAccount()),
                      label: 'Delete Account',
                      iconName: Icons.delete_forever,
                      containerColor: AppTheme.gray,
                      iconColor: AppTheme.green,
                    ),
                    SizedBox(height: height * 0.02),
                    RowProfile(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => const ShowLogout()),
                      label: 'Logout',
                      containerColor: AppTheme.gray,
                      iconColor: AppTheme.green,
                      iconName: Icons.logout_sharp,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
