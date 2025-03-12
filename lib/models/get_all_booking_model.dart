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
      doctorName: json['doctorName'] ?? "",
      doctorId: json['doctorId'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      specializationName: json['specializationName'] ?? "",
      photo: json['photo'],
      day: json['day'] ?? "0001-01-01",
      time: json['time'],
      address: json['address'] ?? "",
    );
  }
}
