import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/widgets/ContainerCanceledAppoinementsDoctor.dart';
import 'package:health_app/widgets/container_upcoming_appoinements_doctor.dart';

class AllAppoinementForDoctor extends StatefulWidget {
  static const String id = '/calendar_doctor';

  const AllAppoinementForDoctor({super.key});

  @override
  State<AllAppoinementForDoctor> createState() =>
      _AllAppoinementForDoctorState();
}

class _AllAppoinementForDoctorState extends State<AllAppoinementForDoctor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  int? doctorId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    doctorId = CacheHelper().getData(key: 'id');
    if (doctorId != null) {
      context
          .read<BookingCubit>()
          .getDoctorCompletedBookings(doctorId: doctorId!);
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
            Text('All Appointments', style: TextStyle(fontSize: 22)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.green,
          labelColor: AppTheme.white,
          unselectedLabelColor: AppTheme.green,
          tabs: [
            _buildTab('All Appointments', 0),
            _buildTab('Cancelled', 1),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<BookingCubit, BookingCubitState>(
          builder: (context, state) {
            if (state is BookingDoctorCompletedLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingDoctorCompletedError) {
              return Center(child: Text(state.message));
            } else if (state is BookingDoctorCompletedSuccess) {
              final appointments = state.bookings;
              return TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (_, index) {
                      final appointment = appointments[index];
                      return ContainerUpComingAppoinementsDoctor(
                        appointment: appointment,
                      );
                    },
                  ),
                  ListView.builder(
                    itemBuilder: (_, index) =>
                        const ContainerCanceledAppoinementsDoctor(),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("No data to show."));
            }
          },
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
