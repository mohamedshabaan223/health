import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/all_appoinements_for_doctor.dart';
import 'package:health_app/pages/doctor_profile_page.dart';
import 'package:health_app/pages/get_all_review_for_doctor.dart';
import 'package:health_app/pages/home_page_doctor.dart';
import 'package:health_app/tabs/chat/display_all_chat.dart';
import 'package:location/location.dart';
import 'package:health_app/cubits/location_cubit/location_cubit.dart';

class HomeScreenDoctor extends StatefulWidget {
  static const String id = '/home-screen-doctor';

  final int selectedIndex;

  const HomeScreenDoctor({super.key, this.selectedIndex = 0});

  @override
  State<HomeScreenDoctor> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreenDoctor> {
  late int selectedIndex;
  final Location _location = Location();
  late final LocationCubit _locCubit;

  List<Widget> tabs = [
    const HomePageDoctor(),
    const DisplayAllChat(),
    const AllAppoinementForDoctor(),
    const GetAllReviewForDoctor(),
    const ProfileDoctor(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    _locCubit = context.read<LocationCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermissions();
    });
  }

  Future<void> _checkLocationPermissions() async {
    bool serviceEnabled = await _location.serviceEnabled();
    PermissionStatus permission = await _location.hasPermission();

    if (!serviceEnabled ||
        permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      _showLocationDialog();
    } else {
      _locCubit.addOrUpdateLocation();
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('تفعيل الموقع'),
        content: const Text(
            'من فضلك قم بتفعيل خدمات الموقع ومنح الأذونات للحصول على إحداثياتك.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              bool serviceEnabled = await _location.requestService();
              PermissionStatus permission = await _location.requestPermission();
              if (serviceEnabled && permission == PermissionStatus.granted) {
                _locCubit.addOrUpdateLocation();
              } else {}
            },
            child: const Text('تفعيل'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: tabs[selectedIndex],
          ),
          BlocConsumer<LocationCubit, LocationState>(
            listener: (context, state) {
              if (state is LocationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث الموقع بنجاح')),
                );
              } else if (state is LocationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is LocationLoading) {
                return const LinearProgressIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined, size: 22),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
