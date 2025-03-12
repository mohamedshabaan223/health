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

  /// دالة لضمان أن `time` يكون بصيغة HH:mm:ss دائمًا
  static String _normalizeTime(String time) {
    // لا تقم بتعديل الوقت إذا كان "00:00"
    if (time == "00:00") {
      return time; // احتفظ بالقيمة الأصلية
    }

    List<String> parts = time.split(':');
    if (parts.length == 2) {
      return "$time:00"; // إضافة الثواني إذا لم تكن موجودة
    }
    return time;
  }

  /// Convert `day` and `time` to `DateTime`
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

  /// Format `day` as `yyyy-MM-dd`
  String get formattedDay {
    try {
      if (day.isEmpty) return "Invalid Date";
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(day));
    } catch (e) {
      debugPrint("Error formatting day: $e");
      return "Invalid Date";
    }
  }

  /// Get the weekday name (e.g., Monday, Tuesday)
  String get weekday {
    try {
      if (day.isEmpty) return "Invalid Date";
      return DateFormat('EEEE').format(DateTime.parse(day));
    } catch (e) {
      debugPrint("Error getting weekday: $e");
      return "Invalid Date";
    }
  }

  /// Format `time` as `HH:mm`
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

  /// Format `time` as `HH:mm:ss`
  String get formattedTimeWithSeconds {
    try {
      return _normalizeTime(time);
    } catch (e) {
      debugPrint("Error formatting time with seconds: $e");
      return "Invalid Time";
    }
  }
}
