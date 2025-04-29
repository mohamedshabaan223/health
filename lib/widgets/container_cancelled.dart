import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/canceled_booking_model.dart';

class ContainerCancelled extends StatelessWidget {
  final CanceledBookingModel bookings;
  const ContainerCancelled({
    super.key,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final imageProvider = bookings.localImagePath != null
        ? FileImage(File(bookings.localImagePath!))
        : const AssetImage('assets/images/doctor_image.png') as ImageProvider;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      width: width * 0.9,
      height: height * 0.16,
      decoration: BoxDecoration(
          color: AppTheme.gray, borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 14.0, top: 8),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: imageProvider,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookings.doctorName,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 16, color: AppTheme.green),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      bookings.specializationName ?? "No Specialization",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(), // هنا عشان ينزل التاريخ للنص
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppTheme.green,
                ),
                child: Text(
                  bookings.bookingDate != null
                      ? '${bookings.bookingDate!.year}-${bookings.bookingDate!.month.toString().padLeft(2, '0')}-${bookings.bookingDate!.day.toString().padLeft(2, '0')}'
                      : 'No Date',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppTheme.white),
                ),
              ),
            ),
            const Spacer(), // يضيف مسافة تحت بعد التاريخ لو حبيت توازن المسافات
          ],
        ),
      ),
    );
  }
}
