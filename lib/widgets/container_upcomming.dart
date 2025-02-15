import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/cancelled_reason_page.dart';

class ContainerUpcoming extends StatelessWidget {
  const ContainerUpcoming({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: width * 0.15,
      height: height * 0.23,
      decoration: BoxDecoration(
          color: AppTheme.gray, borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        AssetImage('assets/images/doctor_image.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. Olivia Turner, M.D.',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 16, color: AppTheme.green),
                      ),
                      Text(
                        'Dermato-Endocrinology',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 130,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: AppTheme.white,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                            color: AppTheme.green,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Friday,12June',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.green,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 155,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: AppTheme.white,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.alarm_add_outlined,
                            size: 20,
                            color: AppTheme.green,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '9:00 Am - 100 Am ',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: AppTheme.green),
                          )
                        ],
                      ),
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
                    height: 30,
                    width: 300,
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
