import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/home_page_patient.dart';
import 'package:health_app/tabs/calendar/calendar.dart';
import 'package:health_app/tabs/chat/display_all_chat.dart';

class HomeScreenPatient extends StatefulWidget {
  static const String id = '/home-screen-patient';

  const HomeScreenPatient({super.key});

  @override
  State<HomeScreenPatient> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreenPatient> {
  int selectedIndex = 0;

  List<Widget> tabs = [
    const HomePagePatient(),
    const DisplayAllChat(),
    const Calendar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.green3,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            unselectedFontSize: 13,
            selectedFontSize: 15,
            selectedItemColor: const Color.fromARGB(255, 59, 133, 106),
            unselectedItemColor: AppTheme.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 22),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline, size: 22),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined, size: 22),
                label: 'Calendar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
