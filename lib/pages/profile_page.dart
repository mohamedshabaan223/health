import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/settings.dart';
import 'package:health_app/pages/update_profile_page.dart';
import 'package:health_app/widgets/row_profile.dart';
import 'package:health_app/widgets/show_logout.dart';

class Profile extends StatelessWidget {
  static const String id = "/profile";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      )),
                  const Spacer(
                    flex: 2,
                  ),
                  const Text(
                    'My Profile',
                    style: TextStyle(
                        color: AppTheme.green,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
            ),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundImage: AssetImage('assets/images/female.png'),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(UpdateProfile.id);
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppTheme.green,
                            border: Border.all(width: 2, color: AppTheme.white),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: AppTheme.white,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(height: height * 0.09),
            RowProfile(
              onTap: () {
                Navigator.of(context).pushNamed(UpdateProfile.id);
              },
              label: 'Profile',
              containerColor: AppTheme.gray,
              iconColor: AppTheme.green,
              iconName: Icons.person_outline,
            ),
            RowProfile(
              onTap: () {
                Navigator.of(context).pushNamed(Setting.id);
              },
              label: 'Setting',
              containerColor: AppTheme.gray,
              iconColor: AppTheme.green,
              iconName: Icons.settings,
            ),
            RowProfile(
              onTap: () => showModalBottomSheet(
                  context: context, builder: (context) => const ShowLogout()),
              label: 'Logout',
              containerColor: AppTheme.gray,
              iconColor: AppTheme.green,
              iconName: Icons.logout_sharp,
            ),
          ],
        ),
      ),
    );
  }
}
