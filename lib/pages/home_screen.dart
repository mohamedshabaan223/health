import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/home_page.dart';
import 'package:health_app/tabs/calendar/calendar.dart';
import 'package:health_app/tabs/chat/chat.dart';
import 'package:health_app/tabs/profile/profile.dart';

class HomeScreen extends StatefulWidget {
 static const String id = '/home';

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  List<Widget> tabs=[
    HomePage(),
    Chat(),
    Profile(),
    Calendar(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
         type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.green3,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
             selectedIndex = index;
            });
          },
          unselectedFontSize: 12,
          selectedFontSize: 14,
          selectedItemColor: const Color.fromARGB(255, 59, 133, 106),
          unselectedItemColor: AppTheme.white,
        items: [ BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 22),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined, size: 22),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, size: 22),
              label: 'Calendar',
            ),]),
    );
  }
}