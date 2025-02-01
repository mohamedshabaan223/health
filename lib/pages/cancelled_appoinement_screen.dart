import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

import 'package:health_app/widgets/container_appoinement.dart';
import 'package:health_app/widgets/container_cancelled.dart';

class CancelledAppointment extends StatelessWidget {
  static const String id = '/cancelled';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ContainerAppointment(
                  onTap: () {
                    // Navigator.of(context).pushNamed(Calendar.id);
                  },
                  label: 'Complete',
                  labelColor: AppTheme.green,
                  containerColor: AppTheme.gray,
                ),
                ContainerAppointment(
                  onTap: () {},
                  label: 'Upcoming',
                  labelColor: AppTheme.green,
                  containerColor: AppTheme.gray,
                ),
                ContainerAppointment(
                  onTap: () {
                    Navigator.of(context).pushNamed(CancelledAppointment.id);
                  },
                  label: 'cancelled',
                  labelColor: AppTheme.white,
                  containerColor: AppTheme.green,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (_, index) => ContainerCancelled()))
          ],
        ),
      ),
      //bottomNavigationBar: CustomButtomNavigationBar(),
    );
  }
}
