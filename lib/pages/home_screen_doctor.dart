import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/all_appoinements_for_doctor.dart';
import 'package:health_app/pages/get_all_review_for_doctor.dart';
import 'package:health_app/pages/home_page_doctor.dart';
import 'package:health_app/tabs/chat/display_all_chat.dart';

class HomeScreenDoctor extends StatefulWidget {
  static const String id = '/home-screen-doctor';

  const HomeScreenDoctor({super.key});

  @override
  State<HomeScreenDoctor> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreenDoctor> {
  int selectedIndex = 0;

  List<Widget> tabs = [
    HomePageDoctor(),
    const DisplayAllChat(),
    const AllAppoinementForDoctor(),
    const GetAllReviewForDoctor(),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.reviews_outlined, size: 22),
                label: 'Reviews',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
