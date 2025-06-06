import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/appointment_screen.dart';

class ContainerSchdule extends StatelessWidget {
  const ContainerSchdule({super.key, this.doctorId, this.doctorName});
  final int? doctorId;
  final String? doctorName;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppointmentScreen.id, arguments: {
          "doctorId": doctorId,
          "doctorName": doctorName,
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        height: 30,
        width: 150,
        decoration: BoxDecoration(
            color: AppTheme.green, borderRadius: BorderRadius.circular(13)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_month,
              color: AppTheme.white,
              size: 22,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              ' booking',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.white,
                    fontSize: 16,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
