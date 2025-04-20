class GetAllBooking {
  final int id;
  final String doctorName;
  final int doctorId;
  final int bookingId;
  final String specializationName;
  final String? photo;
  final String day;
  final String time;
  final String address;

  GetAllBooking({
    required this.id,
    required this.doctorName,
    required this.doctorId,
    required this.bookingId,
    required this.specializationName,
    this.photo,
    required this.day,
    required this.time,
    required this.address,
  });

  factory GetAllBooking.fromJson(Map<String, dynamic> json) {
    return GetAllBooking(
      id: json['id'] ?? 0,
      doctorName: json['doctorName'],
      doctorId: json['doctorId'],
      bookingId: json['bookingId'],
      specializationName: json['specializationName'],
      photo: json['photo'],
      day: json['day'],
      time: json['time'],
      address: json['address'],
    );
  }
}
