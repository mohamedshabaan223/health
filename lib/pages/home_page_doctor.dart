import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/pages/doctor_profile_page.dart';
import 'package:health_app/widgets/custom_user_information.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class HomePageDoctor extends StatefulWidget {
  const HomePageDoctor({super.key});
  static const String id = '/home_page_doctor';

  @override
  State<HomePageDoctor> createState() => _HomePageDoctorState();
}

class _HomePageDoctorState extends State<HomePageDoctor> {
  @override
  void initState() {
    super.initState();
    int? userId = CacheHelper().getData(key: 'id');
    print("User ID from cache: $userId");
    if (userId != null) {
      context.read<UserProfileCubit>().fetchUserProfile(userId);
    } else {
      print("User ID is null!");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            Row(
              children: [
                const CustomUserInformation(),
                const Spacer(),
                SizedBox(width: width * 0.02),
                TopIconInHomePage(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ProfileDoctor.id);
                  },
                  containerBackgroundColor: AppTheme.gray,
                  icons: const Icon(
                    Icons.settings_outlined,
                    size: 22,
                    color: AppTheme.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
