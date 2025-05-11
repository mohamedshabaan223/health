import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/pages/appointment_details_doctor.dart';
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
    double heigth = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            SizedBox(height: heigth * 0.023),
            const Text(
              'Appointments',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: heigth * 0.01),
            Expanded(
              child: BlocBuilder<BookingCubit, BookingCubitState>(
                builder: (context, state) {
                  if (state is BookingDoctorCompletedLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookingDoctorCompletedError) {
                    return Center(child: Text(state.message));
                  } else if (state is BookingDoctorCompletedSuccess) {
                    final appts = state.bookings;
                    if (appts.isEmpty) {
                      return const Center(
                        child: Text("No appointments available."),
                      );
                    }
                    return ListView.builder(
                      itemCount: appts.length,
                      itemBuilder: (_, i) {
                        final apt = appts[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                              AppointementPatientDetails.routeName,
                              arguments: {
                                'bookingId': apt.bookingId,
                                'patientName': apt.patientName,
                              },
                            ).then((cancelled) {
                              Future.delayed(Duration.zero, () {
                                if (!mounted) return;

                                if (cancelled == true && doctorId != null) {
                                  context
                                      .read<BookingCubit>()
                                      .getDoctorCompletedBookings(
                                          doctorId: doctorId!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Appointment cancelled successfully'),
                                    ),
                                  );
                                }
                              });
                            });
                          },
                          child: ContainerUpComingAppoinementsDoctor(
                            appointment: apt,
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("No data to show."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
