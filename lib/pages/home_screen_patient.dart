import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/home_page_patient.dart';
import 'package:health_app/tabs/calendar/calendar.dart';
import 'package:health_app/tabs/chat/display_all_chat.dart';
import 'package:location/location.dart';
import 'package:health_app/cubits/location_cubit/location_cubit.dart';

class HomeScreenPatient extends StatefulWidget {
  static const String id = '/home-screen-patient';
  const HomeScreenPatient({super.key});

  @override
  State<HomeScreenPatient> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreenPatient> {
  int selectedIndex = 0;
  final Location _location = Location();
  late final LocationCubit _locCubit;

  List<Widget> tabs = [
    const HomePagePatient(),
    const DisplayAllChat(),
    const Calendar(),
  ];

  @override
  void initState() {
    super.initState();
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
      // Permissions already granted, update location
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
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.green3,
            currentIndex: selectedIndex,
            onTap: (index) => setState(() => selectedIndex = index),
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
