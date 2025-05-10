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
                  padding: const EdgeInsets.only(left: 14.0, top: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image(
                      image: imageProvider,
                      height: 90,
                      width: 90,
                    ),
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
                    const SizedBox(height: 20),
                    Container(
                      height: 30,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.green,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: AppTheme.white,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            bookings.bookingDate != null
                                ? '${bookings.bookingDate!.year}-${bookings.bookingDate!.month.toString().padLeft(2, '0')}-${bookings.bookingDate!.day.toString().padLeft(2, '0')}'
                                : 'No Date',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppTheme.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
