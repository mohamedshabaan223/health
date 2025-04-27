import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/get_doctor_info_by_id.dart';
import 'package:intl/intl.dart';

class first_screen_in_doctor_app_doctor_info extends StatelessWidget {
  final GetDoctorInfoById getDoctorInfoById;
  const first_screen_in_doctor_app_doctor_info(
      {super.key, required this.groupedByDay, required this.getDoctorInfoById});
  final Map<String, List<Map<String, dynamic>>> groupedByDay;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.02),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: AppTheme.green, width: 1),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/doctor_image.png'),
                ),
                SizedBox(width: width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getDoctorInfoById.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppTheme.green,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      getDoctorInfoById.specialization,
                      style:
                          TextStyle(color: Colors.grey, fontSize: width * 0.04),
                    ),
                    SizedBox(height: height * 0.005),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 20, color: AppTheme.green),
                        Text(getDoctorInfoById.address,
                            style: TextStyle(fontSize: width * 0.04)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 20, color: AppTheme.green),
                        Text(getDoctorInfoById.rating.toString(),
                            style: TextStyle(fontSize: width * 0.04)),
                      ],
                    ),
                    Text(
                      "Experience: ${getDoctorInfoById.experience} years",
                      style: TextStyle(
                          color: Colors.black, fontSize: width * 0.04),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: height * 0.03),
        const Divider(color: AppTheme.green),
        Text(
          "My Schedule:",
          style: TextStyle(
              color: AppTheme.green,
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: height * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedByDay.keys.map((day) {
            DateTime date = DateTime.parse(day);
            String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.green,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: groupedByDay[day]!.map((slot) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                              const BorderSide(color: AppTheme.green, width: 1),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${slot['timeStart']} - ${slot['timeEnd']}",
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "EGP ${slot['price']}",
                                    style: TextStyle(
                                      fontSize: width * 0.035,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: height * 0.02),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
