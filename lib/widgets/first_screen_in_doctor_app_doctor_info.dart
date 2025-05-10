import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/get_doctor_info_by_id.dart';
import 'package:intl/intl.dart';

class FirstScreenInDoctorAppDoctorInfo extends StatelessWidget {
  final GetDoctorInfoById getDoctorInfoById;
  final Map<String, List<Map<String, dynamic>>> groupedByDay;
  final Function(int) onRemoveAppointment;

  const FirstScreenInDoctorAppDoctorInfo({
    super.key,
    required this.groupedByDay,
    required this.getDoctorInfoById,
    required this.onRemoveAppointment,
  });

  Future<void> _showDeleteDialog(
      BuildContext context, int appointmentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Are you sure you want to delete this appointment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onRemoveAppointment(appointmentId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAppointmentsBottomSheet(
      BuildContext context, List<Map<String, dynamic>> slots) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            return Dismissible(
              key: Key(slot['appointmentId'].toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                Navigator.of(context).pop();
                _showDeleteDialog(context, slot['appointmentId']);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppTheme.green, width: 1),
                ),
                child: ListTile(
                  title: Text(
                    "${slot['timeStart']} - ${slot['timeEnd']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("EGP ${slot['price']}"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

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
            side: const BorderSide(color: AppTheme.green, width: 1),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: getDoctorInfoById.localImagePath != null &&
                          File(getDoctorInfoById.localImagePath!).existsSync()
                      ? Image.file(
                          File(getDoctorInfoById.localImagePath!),
                          width: 80,
                          height: 120,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          'assets/images/doctor_image.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
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
                        const Icon(Icons.location_on,
                            size: 20, color: AppTheme.green),
                        Text(
                          getDoctorInfoById.address,
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 20, color: AppTheme.green),
                        Text(
                          getDoctorInfoById.rating.toString(),
                          style: TextStyle(fontSize: width * 0.04),
                        ),
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
        SizedBox(height: height * 0.02),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 110),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.green, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              "Appointments",
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [AppTheme.green, Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                shadows: [
                  Shadow(
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ],
                letterSpacing: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedByDay.keys.map((day) {
            DateTime date = DateTime.parse(day);
            String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.green,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_month,
                          size: 25, color: AppTheme.green2),
                      onPressed: () {
                        _showAppointmentsBottomSheet(
                            context, groupedByDay[day]!);
                      },
                    ),
                  ],
                ),
                SizedBox(height: height * 0.008),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
