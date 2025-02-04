import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/widgets/container_doctor_info.dart';

class DoctorInformation extends StatelessWidget {
  static const String routeName = '/doctor-info';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final doctorId = ModalRoute.of(context)?.settings.arguments as int?;
    if (doctorId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No doctor ID provided.')),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop(DoctorPage.routeName);
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
                        'Doctor Information',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ContainerDoctorInfo(doctorId: doctorId),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  'Profile',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontSize: 17, color: AppTheme.green),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
