import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String id = '/home_page';
  final List<String> images = const [
    'assets/images/alert.png',
    'assets/images/settings.png'
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Image.asset('assets/images/Mask group.png'),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, WelcomeBack',
                          style: TextStyle(color: AppTheme.green)),
                      Text(
                        'John Doe',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: AppTheme.green2),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width * 0.22,
                  ),
                  Row(
                    children: [
                      const TopIconInHomePage(
                        containerBackgroundColor: AppTheme.gray,
                        icons: Icon(
                          Icons.notifications_outlined,
                          size: 25,
                          color: AppTheme.green,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      const TopIconInHomePage(
                        containerBackgroundColor: AppTheme.gray,
                        icons: Icon(
                          Icons.settings_outlined,
                          size: 25,
                          color: AppTheme.green,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
