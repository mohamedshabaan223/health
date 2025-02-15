import 'package:flutter/material.dart';

import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/change_password.dart';
import 'package:health_app/widgets/row_settings.dart';

class Setting extends StatelessWidget {
  static const String id = "/setting";
  @override
  Widget build(BuildContext context) {
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
                    'Setting',
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
            const SizedBox(
              height: 20,
            ),
            const RowSetting(
              iconName: Icons.notifications,
              label: 'notification setting',
              iconName2: Icons.keyboard_arrow_right,
            ),
            const SizedBox(
              height: 10,
            ),
            RowSetting(
              onTap: () {
                Navigator.of(context).pushNamed(ChangePassword.id);
              },
              iconName: Icons.key,
              label: 'password manager',
              iconName2: Icons.keyboard_arrow_right,
            ),
            const SizedBox(
              height: 10,
            ),
            const RowSetting(
              iconName: Icons.person_2_outlined,
              label: 'delete account',
              iconName2: Icons.keyboard_arrow_right,
            )
          ],
        ),
      ),
    );
  }
}
