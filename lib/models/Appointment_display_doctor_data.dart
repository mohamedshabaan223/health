class AppointmentDisplayDoctorData {
  final String day;
  final String name;
  final String timeStart;
  final String timeEnd;
  final int appointmentId;
  final int price;

  AppointmentDisplayDoctorData({
    required this.day,
    required this.name,
    required this.timeStart,
    required this.timeEnd,
    required this.appointmentId,
    required this.price,
  });

  factory AppointmentDisplayDoctorData.fromJson(Map<String, dynamic> json) {
    return AppointmentDisplayDoctorData(
      day: json['day'] ?? '',
      name: json['name'] ?? '',
      timeStart: json['timeStart'] ?? '',
      timeEnd: json['timeEnd'] ?? '',
      appointmentId: json['appointmentId'] ?? 0,
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'name': name,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'appointmentId': appointmentId,
      'price': price,
    };
  }

  String get timeRange => "$timeStart - $timeEnd";
}
