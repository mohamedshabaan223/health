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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 25, color: AppTheme.green),
                  ),
                  const Spacer(),
                  const Text(
                    'Password Manager',
                    style: TextStyle(
                      color: AppTheme.green,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 30),
              _buildPasswordField(
                  context, 'Current Password', cubit.currentPasswordController),
              _buildPasswordField(
                  context, 'New Password', cubit.newPasswordController),
              _buildPasswordField(context, 'Confirm New Password',
                  cubit.confirmNewPasswordController),
              const SizedBox(height: 30),
              BlocConsumer<UserProfileCubit, UserProfileState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("تم تغيير كلمة المرور بنجاح")),
                    );
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  } else if (state is ChangePasswordFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is ChangePasswordLoading
                        ? null
                        : () => cubit.changePassword(userId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 50),
                    ),
                    child: state is ChangePasswordLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      BuildContext context, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        UpdateTextField(
          hintText: '************',
          isPassword: true,
          controller: controller,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
