import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

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
      time: _normalizeTime(json['time'] ?? ""),
      appointmentId: json['appointmentId'] ?? 0,
    );
  }

  static String _normalizeTime(String time) {
    if (time == "00:00") {
      return time;
    }

    List<String> parts = time.split(':');
    if (parts.length == 2) {
      return "$time:00";
    }
    return time;
  }

  DateTime? get dateTime {
    try {
      if (day.isEmpty || time.isEmpty) return null;
      DateTime parsedDate = DateTime.parse(day);
      List<String> parts = time.split(':');
      if (parts.length < 3) return null;
      return DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (e) {
      debugPrint("Error parsing dateTime: $e");
      return null;
    }
  }

  String get formattedDay {
    try {
      if (day.isEmpty) return "Invalid Date";
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(day));
    } catch (e) {
      debugPrint("Error formatting day: $e");
      return "Invalid Date";
    }
  }

  String get weekday {
    try {
      if (day.isEmpty) return "Invalid Date";
      return DateFormat('EEEE').format(DateTime.parse(day));
    } catch (e) {
      debugPrint("Error getting weekday: $e");
      return "Invalid Date";
    }
  }

  String get formattedTime {
    try {
      List<String> parts = time.split(':');
      if (parts.length < 2) return "Invalid Time";
      return DateFormat.Hm()
          .format(DateTime(0, 1, 1, int.parse(parts[0]), int.parse(parts[1])));
    } catch (e) {
      debugPrint("Error formatting time: $e");
      return "Invalid Time";
    }
  }

  String get formattedTimeWithSeconds {
    try {
      return _normalizeTime(time);
    } catch (e) {
      debugPrint("Error formatting time with seconds: $e");
      return "Invalid Time";
    }
  }
}
