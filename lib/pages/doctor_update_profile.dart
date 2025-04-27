import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_state.dart';
import 'package:health_app/pages/home_screen_doctor.dart';
import 'package:health_app/widgets/image_profile.dart';
import 'package:health_app/widgets/update_doctor_slots_day_time.dart';
import 'package:health_app/widgets/update_text_field.dart';

class DoctorUpdateProfile extends StatefulWidget {
  const DoctorUpdateProfile({super.key});
  static const String id = '/doctor_update_profile';

  @override
  State<DoctorUpdateProfile> createState() => _DoctorUpdateProfileState();
}

class _DoctorUpdateProfileState extends State<DoctorUpdateProfile> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileCubit = BlocProvider.of<UserProfileCubit>(context);
    int userId = CacheHelper().getData(key: 'id');

    return Scaffold(
      appBar: AppBar(
        titleSpacing: MediaQuery.of(context).size.width * 0.2,
        title: const Column(
          children: [
            SizedBox(height: 15),
            Text(
              'My Profile',
              style: TextStyle(
                color: Color(0xFF58CFA4),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(child: DoctorImageProfile()),
              const SizedBox(height: 15),
              _buildProfileField(
                  context, 'Email', profileCubit.doctorEmailController),
              _buildProfileField(
                  context, 'Phone number', profileCubit.doctorPhoneController),
              _buildProfileField(
                  context, 'Address', profileCubit.doctorAdressController),
              _buildProfileField(context, 'Experience',
                  profileCubit.doctorExperienceController),
              _buildProfileField(
                  context, 'Focus', profileCubit.doctorFocusController),
              const SizedBox(height: 8),
              UpdateDoctorSlotsDayTime(
                  doctorName: CacheHelper().getData(key: 'name')),
              const SizedBox(height: 15),
              _buildUpdateButton(context, profileCubit, userId),
            ],
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
          Text(label,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
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
            MaterialPageRoute(
                builder: (context) => const HomeScreenDoctor(selectedIndex: 4)),
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
              onTap: () => profileCubit.updateDoctorProfile(userId),
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
