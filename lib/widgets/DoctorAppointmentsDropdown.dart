import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/get_doctor_info_by_id.dart';

class DoctorAppointmentsDropdown extends StatelessWidget {
  final List<AvailableAppointment> availableAppointments;

  const DoctorAppointmentsDropdown(
      {super.key, required this.availableAppointments});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 35,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.green),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<AvailableAppointment>(
            dropdownColor: AppTheme.gray,
            isExpanded: true,
            borderRadius: BorderRadius.circular(25),
            hint: Row(
              children: [
                const Icon(Icons.alarm, color: AppTheme.green, size: 18),
                const SizedBox(width: 5),
                Text(
                  availableAppointments.isNotEmpty
                      ? "${availableAppointments.first.day} - ${availableAppointments.first.time}"
                      : "No Time Available",
                  style: const TextStyle(color: AppTheme.green, fontSize: 14),
                ),
              ],
            ),
            icon: const Icon(Icons.arrow_drop_down, color: AppTheme.green),
            onChanged: (_) {},
            items: availableAppointments.map((appointment) {
              return DropdownMenuItem<AvailableAppointment>(
                value: appointment,
                enabled: false,
                child: Row(
                  children: [
                    const Icon(Icons.alarm, color: AppTheme.green, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "${appointment.day} - ${appointment.time}",
                      style: const TextStyle(
                        color: AppTheme.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
