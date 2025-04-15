import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/widgets/ContainerCanceledAppoinementsDoctor.dart';
import 'package:health_app/widgets/ContainerCompleteAppoinementsDoctor.dart';
import 'package:health_app/widgets/container_cancelled.dart';
import 'package:health_app/widgets/container_complete_doctor.dart';
import 'package:health_app/widgets/container_upcoming_appoinements_doctor.dart';

class AllAppoinementForDoctor extends StatefulWidget {
  static const String id = '/calendar';

  const AllAppoinementForDoctor({super.key});

  @override
  State<AllAppoinementForDoctor> createState() =>
      _AllAppoinementForDoctorState();
}

class _AllAppoinementForDoctorState extends State<AllAppoinementForDoctor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });

    final doctorId = CacheHelper().getData(key: 'id');
    if (doctorId != null) {
      context.read<BookingCubit>().getDoctorBookings(doctorId: doctorId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          children: [
            SizedBox(height: 10),
            Text(
              'All Appointments',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.green,
          labelColor: AppTheme.white,
          unselectedLabelColor: AppTheme.green,
          tabs: [
            _buildTab('Complete', 0),
            _buildTab('Upcoming', 1),
            _buildTab('Cancelled', 2),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              itemBuilder: (_, index) => ContainerCompleteAppoinementsDoctor(),
            ),
            BlocBuilder<BookingCubit, BookingCubitState>(
              builder: (context, state) {
                if (state is BookingCubitLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingCubitGetAllError) {
                  return Center(child: Text(state.errormessage));
                } else if (state is BookingCubitGetAllAppointmentSuccess) {
                  final bookings = state.bookings;
                  if (bookings.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (_, index) {
                      return ContainerUpComingAppoinementsDoctor(
                        allAppoinementModel: bookings[index],
                      );
                    },
                  );
                }
                return const Center(child: Text('No data available'));
              },
            ),
            ListView.builder(
              itemBuilder: (_, index) => ContainerCanceledAppoinementsDoctor(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? AppTheme.green : AppTheme.gray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: _selectedIndex == index ? AppTheme.white : AppTheme.green,
          ),
        ),
      ),
    );
  }
}
