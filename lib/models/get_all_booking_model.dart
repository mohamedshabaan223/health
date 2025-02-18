class GetAllBooking {
  final int id;
  final String doctorName;
  final String specializationName;
  final String? photo;
  final String day;
  final String time;
  final String address;

  GetAllBooking({
    required this.id,
    required this.doctorName,
    required this.specializationName,
    this.photo,
    required this.day,
    required this.time,
    required this.address,
  });

  factory GetAllBooking.fromJson(Map<String, dynamic> json) {
    return GetAllBooking(
      id: json['id'] as int,
      doctorName: json['doctorName'] as String,
      specializationName: json['specializationName'] as String,
      photo: json['photo'] as String?,
      day: json['day'] as String,
      time: json['time'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'specializationName': specializationName,
      'photo': photo,
      'day': day,
      'time': time,
      'address': address,
    };
  }
}
