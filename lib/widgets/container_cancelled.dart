import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/canceled_booking_model.dart';
import 'package:health_app/pages/cancelled_reason_page.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      width: width * 0.15,
      height: height * 0.16,
      decoration: BoxDecoration(
          color: AppTheme.gray, borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14.0, top: 8),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/male.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookings.doctorName,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 16, color: AppTheme.green),
                      ),
                      Text(
                        'Dermato-Genetics',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 155,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: AppTheme.green),
                  child: Text(
                    '${bookings.bookingDate.day}/${bookings.bookingDate.month}/${bookings.bookingDate.year}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppTheme.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
