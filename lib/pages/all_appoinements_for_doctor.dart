import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/widgets/container_upcoming_appoinements_doctor.dart';

class AllAppoinementForDoctor extends StatefulWidget {
  static const String id = '/calendar_doctor';

  const AllAppoinementForDoctor({super.key});

  @override
  State<AllAppoinementForDoctor> createState() =>
      _AllAppoinementForDoctorState();
}

class _AllAppoinementForDoctorState extends State<AllAppoinementForDoctor> {
  int? doctorId;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              SizedBox(height: 12),
              Text('All Appointments', style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: BlocBuilder<BookingCubit, BookingCubitState>(
                builder: (context, state) {
                  if (state is BookingDoctorCompletedLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookingDoctorCompletedError) {
                    return Center(child: Text(state.message));
                  } else if (state is BookingDoctorCompletedSuccess) {
                    final appointments = state.bookings;
                    if (appointments.isEmpty) {
                      return const Center(
                          child: Text("No appointments available."));
                    }
                    return ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (_, index) {
                        final appointment = appointments[index];
                        return ContainerUpComingAppoinementsDoctor(
                          appointment: appointment,
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No data to show."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
