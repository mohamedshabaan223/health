import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/widgets/container_doctor_info.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class DoctorInformation extends StatelessWidget {
  static const String routeName = '/doctor-info';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(DoctorPage.routeName);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 30,
                            color: AppTheme.green,
                          )),
                      Text(
                        'Doctor Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          TopIconInHomePage(
                              icons: Icon(
                                Icons.search,
                                color: AppTheme.green,
                              ),
                              containerBackgroundColor: AppTheme.gray),
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                              onTap: () {},
                              child: Image.asset('assets/images/filter1.png')),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ContainerDoctorInfo(),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  'Career Path',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  'Hightlight',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(
                  height: height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
