class AllAppoinementModel {
  final DateTime date;
  final String message;
  final String? senderName;
  final String day;
  final String time;
  final String cleanMessage;

  AllAppoinementModel({
    required this.date,
    required this.message,
    this.senderName,
  })  : day = _extractDay(message ?? ''),
        time = _extractTime(message ?? ''),
        cleanMessage = _extractCleanMessage(message ?? '');

  factory AllAppoinementModel.fromJson(Map<String, dynamic> json) {
    return AllAppoinementModel(
      date: DateTime.parse(json['date']),
      message: json['message'] ?? '', // تأكد من عدم تمرير null
      senderName: json['senderName'],
    );
  }

  /// استخراج اليوم من الرسالة
  static String _extractDay(String message) {
    if (message.isEmpty) return 'Unknown';
    final RegExp regex = RegExp(r'for (\d{1,2}/\d{1,2}/\d{4})');
    final match = regex.firstMatch(message);
    return match != null ? match.group(1)! : 'Unknown';
  }

  /// استخراج الوقت من الرسالة
  static String _extractTime(String message) {
    if (message.isEmpty) return 'Unknown';
    final RegExp regex = RegExp(r'time (\d{1,2}:\d{2} ?[APM]{0,2})');
    final match = regex.firstMatch(message);

    if (match != null) {
      String extractedTime = match.group(1)!;
      if (!extractedTime.contains("AM") && !extractedTime.contains("PM")) {
        extractedTime += " AM";
      }
      return extractedTime;
    }

    return 'Unknown';
  }

  /// استخراج الرسالة بدون التاريخ والوقت
  static String _extractCleanMessage(String message) {
    if (message.isEmpty) return 'Unknown';
    return message
        .replaceAll(
            RegExp(r'for \d{1,2}/\d{1,2}/\d{4} time \d{1,2}:\d{2} ?[APM]{0,2}'),
            '')
        .trim();
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'message': message,
      'senderName': senderName,
      'day': day,
      'time': time,
      'cleanMessage': cleanMessage,
    };
  }
}
