import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/widgets/row_details.dart';

class AppointementPatientDetails extends StatefulWidget {
  const AppointementPatientDetails({super.key});
  static const String routeName = '/appointement_patient_details';

  @override
  _AppointementPatientDetailsState createState() =>
      _AppointementPatientDetailsState();
}

class _AppointementPatientDetailsState
    extends State<AppointementPatientDetails> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  int? bookingId;
  String? patientName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;

    if (args != null) {
      bookingId = args['bookingId'] as int?;
      patientName = args['patientName'] as String?;

      if (bookingId != null && mounted) {
        context.read<BookingCubit>().getBookingDetails(bookingId: bookingId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF58CFA4),
        leadingWidth: 100,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                if (!mounted) return;
                context.read<BookingCubit>().getDoctorCompletedBookings(
                      doctorId: CacheHelper().getData(key: 'id'),
                    );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 25),
            ),
            const Spacer(),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              patientName ?? 'Unknown',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<BookingCubit, BookingCubitState>(
          builder: (context, state) {
            if (state is BookingCubitLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingCubitError) {
              return Center(child: Text(state.errormessage));
            } else if (state is BookingCubitBookingDetailsSuccess) {
              final bookingDetails = state.bookingDetails;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppTheme.gray,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'Appointment Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RowDetails(label: 'Date: ', details: bookingDetails.day),
                  const SizedBox(height: 5),
                  RowDetails(label: 'Time: ', details: bookingDetails.time),
                  const SizedBox(height: 15),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppTheme.gray,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'Patient Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RowDetails(
                      label: 'Full Name: ',
                      details: bookingDetails.patientName),
                  const SizedBox(height: 8),
                  RowDetails(
                      label: 'Age: ', details: '${bookingDetails.age} Years'),
                  const SizedBox(height: 8),
                  RowDetails(label: 'Gender: ', details: bookingDetails.gender),
                  const SizedBox(height: 8),
                  RowDetails(
                      label: 'Phone no: ', details: bookingDetails.phone),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Problem Description:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bookingDetails.problemDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.green2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Cancel Appointment'),
                              content: const Text(
                                  'Are you sure you want to cancel this appointment?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    if (bookingId != null) {
                                      await context
                                          .read<BookingCubit>()
                                          .cancelAppointment(id: bookingId!);

                                      context
                                          .read<BookingCubit>()
                                          .getDoctorCompletedBookings(
                                            doctorId: CacheHelper()
                                                .getData(key: 'id'),
                                          );
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                      BlocProvider.of<BookingCubit>(context)
                                          .getDoctorCompletedBookings(
                                              doctorId: CacheHelper()
                                                  .getData(key: 'id'));
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.gray,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: 250,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '!',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Cancel Appointment',
                                style: TextStyle(
                                  color: AppTheme.green2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
}
