import 'package:intl/intl.dart'; // استيراد مكتبة intl لتنسيق الوقت

class AppointmentDisplayDoctorData {
  final String time;
  final int appointmentId;

  AppointmentDisplayDoctorData({
    required this.time,
    required this.appointmentId,
  });

  factory AppointmentDisplayDoctorData.fromJson(Map<String, dynamic> json) {
    return AppointmentDisplayDoctorData(
      time: json['time'] ?? "",
      appointmentId: json['appointmentId'] ?? 0,
    );
  }

  String get day {
    try {
      DateTime parsedTime = DateTime.parse(time);
      return parsedTime.day.toString();
    } catch (e) {
      return "Invalid Date";
    }
  }

  String get weekday {
    try {
      DateTime parsedTime = DateTime.parse(time);
      return _weekdayName(parsedTime.weekday);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// ✅ **إضافة دالة استخراج الوقت فقط بصيغة `HH:mm` (مثال: "14:30")**
  String get formattedTime {
    try {
      DateTime parsedTime = DateTime.parse(time);
      return DateFormat.Hm().format(parsedTime); // 🔥 "14:30"
    } catch (e) {
      return "Invalid Time";
    }
  }

  String _weekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "Unknown";
    }
  }
}
