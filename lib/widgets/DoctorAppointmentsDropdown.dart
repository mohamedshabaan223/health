import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/get_doctor_info_by_id.dart';

class DoctorAppointmentsDropdown extends StatelessWidget {
  final List<AvailableSlot> availableAppointments;
  final Function(AvailableSlot) onSlotSelected;
  final AvailableSlot? selectedSlot; // ✅ أضيفي دي

  const DoctorAppointmentsDropdown({
    super.key,
    required this.availableAppointments,
    required this.onSlotSelected,
    this.selectedSlot,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 35,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.green),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<AvailableSlot>(
            value: selectedSlot,
            dropdownColor: AppTheme.gray,
            isExpanded: true,
            borderRadius: BorderRadius.circular(25),
            hint: Row(
              children: [
                const Icon(Icons.alarm, color: AppTheme.green, size: 18),
                const SizedBox(width: 5),
                Text(
                  availableAppointments.isNotEmpty
                      ? "${availableAppointments.first.day} - ${availableAppointments.first.timeStart}"
                      : "No Time Available",
                  style: const TextStyle(color: AppTheme.green, fontSize: 14),
                ),
              ],
            ),
            icon: const Icon(Icons.arrow_drop_down, color: AppTheme.green),
            onChanged: (selected) {
              if (selected != null) {
                onSlotSelected(selected);
              }
            },
            items: availableAppointments.map((appointment) {
              return DropdownMenuItem<AvailableSlot>(
                value: appointment,
                child: Row(
                  children: [
                    const Icon(Icons.alarm, color: AppTheme.green, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "${appointment.day} - ${appointment.timeStart}",
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
