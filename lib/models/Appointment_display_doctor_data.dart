import 'package:intl/intl.dart';

class AppointmentDisplayDoctorData {
  final String day;
  final String time;
  final int appointmentId;

  AppointmentDisplayDoctorData({
    required this.day,
    required this.time,
    required this.appointmentId,
  });

  factory AppointmentDisplayDoctorData.fromJson(Map<String, dynamic> json) {
    return AppointmentDisplayDoctorData(
      day: json['day'] ?? "",
      time: json['time'] ?? "",
      appointmentId: json['appointmentId'] ?? 0,
    );
  }

  DateTime? get dateTime {
    try {
      if (day.isEmpty || time.isEmpty) return null;
      DateTime parsedDate = DateTime.parse(day);
      List<String> parts = time.split(':');
      if (parts.length < 2) return null;
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      return DateTime(
          parsedDate.year, parsedDate.month, parsedDate.day, hours, minutes);
    } catch (e) {
      return null;
    }
  }

  String get formattedDay {
    try {
      if (day.isEmpty) return "Invalid Date";
      DateTime parsedDate = DateTime.parse(day);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  String get weekday {
    try {
      if (day.isEmpty) return "Invalid Date";
      return DateFormat('EEEE').format(DateTime.parse(day));
    } catch (e) {
      return "Invalid Date";
    }
  }

  String get formattedTime {
    try {
      List<String> parts = time.split(':');
      if (parts.length < 2) return "Invalid Time";
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      return DateFormat.Hm().format(DateTime(0, 1, 1, hours, minutes));
    } catch (e) {
      return "Invalid Time";
    }
  }
}
