import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/widgets/container_cancelled.dart';
import 'package:health_app/widgets/container_upcomming.dart';

class Calendar extends StatefulWidget {
  static const String id = '/calendar';

  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

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

    final patientId = CacheHelper().getData(key: 'id');
    if (patientId != null) {
      final cubit = context.read<BookingCubit>();
      cubit.getAllBookings(patientId: patientId);
      cubit.getAllCanceledBookings(patientId: patientId);
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
              'All Appointment',
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
            Tab(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? AppTheme.green : AppTheme.gray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'All Appointments',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _selectedIndex == 0 ? AppTheme.white : AppTheme.green,
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 ? AppTheme.green : AppTheme.gray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Cancelled',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _selectedIndex == 1 ? AppTheme.white : AppTheme.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            BlocBuilder<BookingCubit, BookingCubitState>(
              buildWhen: (previous, current) =>
                  current is BookingCubitGetAllSuccess ||
                  current is BookingCubitLoading ||
                  current is BookingCubitGetAllError,
              builder: (context, state) {
                if (state is BookingCubitLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingCubitError) {
                  return Center(child: Text(state.errormessage));
                } else {
                  final upcomingBookings = (state is BookingCubitGetAllSuccess)
                      ? state.bookings
                      : context.read<BookingCubit>().bookings;

                  if (upcomingBookings.isEmpty) {
                    return const Center(child: Text('No Upcoming Bookings.'));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      final patientId = CacheHelper().getData(key: 'id');
                      if (patientId != null) {
                        await context
                            .read<BookingCubit>()
                            .getAllBookings(patientId: patientId);
                      }
                    },
                    child: ListView.builder(
                      itemCount: upcomingBookings.length,
                      itemBuilder: (_, index) {
                        final booking = upcomingBookings[index];
                        return ContainerUpcoming(booking: booking);
                      },
                    ),
                  );
                }
              },
            ),
            BlocBuilder<BookingCubit, BookingCubitState>(
              buildWhen: (previous, current) =>
                  current is BookingCubitAllCanceledSuccess ||
                  current is BookingCubitAllCanceledEmpty ||
                  current is BookingCubitLoading ||
                  current is BookingCubitError,
              builder: (context, state) {
                if (state is BookingCubitLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingCubitError) {
                  return Center(child: Text(state.errormessage));
                } else {
                  final canceledBookings =
                      (state is BookingCubitAllCanceledSuccess)
                          ? state.canceledBookings
                          : context.read<BookingCubit>().canceledBookings;

                  if (canceledBookings.isEmpty) {
                    return const Center(child: Text('لا توجد حجوزات ملغية.'));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      final patientId = CacheHelper().getData(key: 'id');
                      if (patientId != null) {
                        await context
                            .read<BookingCubit>()
                            .getAllCanceledBookings(patientId: patientId);
                      }
                    },
                    child: ListView.builder(
                      itemCount: canceledBookings.length,
                      itemBuilder: (_, index) {
                        final booking = canceledBookings[index];
                        return ContainerCancelled(bookings: booking);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
