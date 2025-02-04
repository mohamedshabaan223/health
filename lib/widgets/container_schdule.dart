import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/appointment_screen.dart';

class ContainerSchdule extends StatelessWidget {
  const ContainerSchdule({super.key, this.doctorId});
  final int? doctorId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppointmentScreen.id, arguments: doctorId);
      },
      child: Container(
        padding: EdgeInsets.only(left: 5),
        height: 30,
        width: 110,
        decoration: BoxDecoration(
            color: AppTheme.green, borderRadius: BorderRadius.circular(13)),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: AppTheme.white,
              size: 25,
            ),
            Text(
              'schedule',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.white,
                    fontSize: 15,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
