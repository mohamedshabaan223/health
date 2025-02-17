import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_state.dart';
import 'package:health_app/pages/home_screen.dart';
import 'package:health_app/widgets/update_text_field.dart';

class ChangePassword extends StatelessWidget {
  static const String id = "/change_password";

  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserProfileCubit>();
    int userId = CacheHelper().getData(key: 'id');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 25, color: AppTheme.green),
                    ),
                    const Spacer(flex: 2),
                    const Text(
                      'Password Manager',
                      style: TextStyle(
                        color: AppTheme.green,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Current Password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              UpdateTextField(
                isPassword: true,
                controller: cubit.currentPasswordController,
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 20),
              Text(
                'New Password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              UpdateTextField(
                isPassword: true,
                controller: cubit.newPasswordController,
              ),
              const SizedBox(height: 20),
              Text(
                'Confirm New Password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              UpdateTextField(
                isPassword: true,
                controller: cubit.confirmNewPasswordController,
              ),
              const Spacer(flex: 3),
              BlocConsumer<UserProfileCubit, UserProfileState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("تم تغيير كلمة المرور بنجاح ")),
                    );
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  } else if (state is ChangePasswordFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: InkWell(
                      onTap: state is ChangePasswordLoading
                          ? null
                          : () => cubit.changePassword(userId),
                      child: Container(
                        alignment: Alignment.center,
                        height: 48,
                        width: 300,
                        decoration: BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: state is ChangePasswordLoading
                            ? const CircularProgressIndicator(
                                color: AppTheme.white)
                            : const Text(
                                'Change Password',
                                style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
