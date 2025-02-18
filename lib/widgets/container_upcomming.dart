import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/get_all_booking_model.dart';

class ContainerUpcoming extends StatelessWidget {
  final GetAllBooking booking;

  const ContainerUpcoming({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: width * 0.15,
      height: height * 0.23,
      decoration: BoxDecoration(
        color: AppTheme.gray,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage:
                        AssetImage('assets/images/doctor_image.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.doctorName,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 16, color: AppTheme.green),
                      ),
                      Text(
                        booking.specializationName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppTheme.green,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            booking.address,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: width * 0.3,
                  height: height * 0.03,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: AppTheme.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color: AppTheme.green,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          booking.day,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.green,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: width * 0.25,
                  height: height * 0.03,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: AppTheme.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.alarm_add_outlined,
                          size: 20,
                          color: AppTheme.green,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          booking.time,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.green),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    height: height * 0.04,
                    width: width * 0.7,
                    decoration: BoxDecoration(
                        color: AppTheme.green,
                        borderRadius: BorderRadius.circular(18)),
                    child: Text(
                      'Update Booking',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppTheme.white),
                    ),
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
