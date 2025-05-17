import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/core/api/dio_consumer.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/pages/appointment_screen.dart';
import 'package:health_app/pages/payment_page.dart';
import 'package:health_app/widgets/start_screen_button.dart';
import 'package:health_app/cubits/payment_cubit/payment_cubit.dart';
import 'package:health_app/cubits/payment_cubit/payment_state.dart';

class YourAppoinment extends StatelessWidget {
  const YourAppoinment({super.key});
  static const String id = '/your_appoinment';

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> arguments =
        (args is Map<String, dynamic>) ? args : {};

    final int doctorId = arguments["doctorId"] ?? 0;
    final String day = arguments["day"] ?? "Unknown";
    final String time = arguments["time"] ?? "Unknown";
    final bool forHimSelf = arguments["forHimSelf"] ?? false;

    final String patientName = arguments["patientName"] != null &&
            arguments["patientName"].toString().isNotEmpty
        ? arguments["patientName"]
        : (forHimSelf
            ? context.read<AuthCubit>().registerUserName.text
            : "Unknown");

    final String gender = arguments["gender"] ?? "Unknown";
    final int age = arguments["age"] ?? 0;
    final int patientId = arguments["patientId"] ?? 0;
    final String problemDescription = arguments["problemDescription"] ?? "";

    final int bookingId = arguments["bookingId"] ?? 0;

    final String doctorName = arguments["doctorName"] ?? "Unknown";

    if (doctorId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(context, "Doctor ID is missing or invalid");
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => PaymentCubit(DioConsumer(dio: Dio())),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: BlocBuilder<BookingCubit, BookingCubitState>(
                  builder: (context, state) {
                    if (state is BookingCubitDataLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BookingCubitDataSuccess) {
                      final bookingData = state.bookingResponse;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(AppointmentScreen.id);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  size: 25,
                                  color: AppTheme.green,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.07,
                              ),
                              Text(doctorName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppTheme.green2,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: AppTheme.green,
                                  size: 20,
                                ),
                                Text(' Day',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppTheme.green,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(
                              day,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: AppTheme.green,
                                  size: 20,
                                ),
                                Text(' Time',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppTheme.green,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(
                              time,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        const Divider(
                          color: AppTheme.green,
                          thickness: 1.2,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppTheme.green,
                                  size: 20,
                                ),
                                Text(
                                  ' Booking For',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppTheme.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              forHimSelf ? 'Yourself' : 'Another Person',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.cake,
                                  color: AppTheme.green,
                                  size: 20,
                                ),
                                Text(
                                  ' Age',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppTheme.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              age.toString(),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.man_outlined,
                                  color: AppTheme.green,
                                  size: 20,
                                ),
                                Text(
                                  ' Gender',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppTheme.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              gender,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: width * 0.02,
                        ),
                        const Divider(
                          color: AppTheme.green,
                          thickness: 1.2,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        const Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description,
                                  color: AppTheme.green,
                                  size: 20,
                                ),
                                Text(
                                  ' Problem',
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: AppTheme.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.green3.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppTheme.green.withOpacity(0.3)),
                          ),
                          child: Text(
                            problemDescription,
                            style: const TextStyle(fontSize: 14),
                            softWrap: true,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.08,
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        BlocConsumer<PaymentCubit, PaymentState>(
                          listener: (context, state) {
                            if (state is PaymentSuccess) {
                              _launchPaymentUrl(
                                  context, state.paymentUrl, bookingId);
                            }
                            if (state is PaymentFailure) {
                              _showErrorDialog(context,
                                  "Payment failed: ${state.errorMessage}");
                            }
                          },
                          builder: (context, state) {
                            if (state is PaymentLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            return StartScreenButton(
                              label: 'Card or Debit',
                              onPressed: () {
                                if (doctorId != null) {
                                  context.read<PaymentCubit>().makePayment(
                                      doctorId: doctorId, bookingId: bookingId);
                                } else {
                                  _showErrorDialog(
                                      context, "Doctor ID is invalid");
                                }
                              },
                              buttonBackgroundColor: doctorId != null
                                  ? AppTheme.green
                                  : Colors.grey,
                              buttonForegroundColor: AppTheme.white,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchPaymentUrl(
      BuildContext context, String? url, int bookingId) async {
    if (url == null || url.isEmpty) {
      debugPrint("Invalid payment URL");
      _showErrorDialog(context, "Invalid payment URL");
      return;
    }

    // Navigate to botumSheet with the payment URL
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          paymentUrl: url,
          bookingId: bookingId,
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

Widget _buildInfoContainer({
  required String text,
  required double width,
}) {
  return Container(
    width: width,
    height: 30,
    decoration: BoxDecoration(
      color: AppTheme.green3,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
