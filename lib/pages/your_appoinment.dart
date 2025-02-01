import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/appointment_screen.dart';
import 'package:health_app/widgets/card_of_doctor.dart';
import 'package:health_app/widgets/start_screen_button.dart';

class YourAppoinment extends StatelessWidget {
  const YourAppoinment({super.key});
  static const String id = '/your_appoinment';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(AppointmentScreen.id);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 25,
                              color: AppTheme.green,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.15,
                          ),
                          Text(
                            'Your Appoinment',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 20,
                                    color: AppTheme.green,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const CardOfDoctor(),
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
                      children: [
                        _buildInfoContainer(
                            text: '24 WED 2024', width: width * 0.5),
                        SizedBox(
                          width: width * 0.1,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.check_circle,
                            color: AppTheme.green,
                            size: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.cancel,
                            color: AppTheme.green,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '             at 10:00 AM',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 15,
                                  color: AppTheme.green,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    const Divider(
                      color: AppTheme.green,
                      thickness: 1.2,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Booking For',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Another Person',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.012,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Full Name',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Habiba',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.012,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Age',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '22',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.012,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          ' Female',
                          style: TextStyle(fontSize: 15),
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
                        Text(
                          'Problem',
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    StartScreenButton(
                        label: 'Pay Cash',
                        onPressed: () {},
                        buttonBackgroundColor: AppTheme.green,
                        buttonForegroundColor: AppTheme.white),
                    StartScreenButton(
                        label: 'Card or Debit',
                        onPressed: () {},
                        buttonBackgroundColor: AppTheme.green,
                        buttonForegroundColor: AppTheme.white)
                  ],
                ),
              ),
            ),
          ),
        ),
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
