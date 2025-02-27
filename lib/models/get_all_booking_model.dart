class GetAllBooking {
  final int id;
  final int doctorId;
  final int bookingId;
  final String doctorName;
  final String specializationName;
  final String? photo;
  final String day;
  final String time;
  final String address;

  GetAllBooking({
    required this.id,
    required this.doctorId,
    required this.bookingId,
    required this.doctorName,
    required this.specializationName,
    this.photo,
    required this.day,
    required this.time,
    required this.address,
  });

  factory GetAllBooking.fromJson(json) {
    return GetAllBooking(
      id: json['id'] as int,
      doctorId: json['doctorId'] as int,
      bookingId: json['bookingId'] as int,
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
      'doctorId': doctorId,
      'bookingId': bookingId,
      'doctorName': doctorName,
      'specializationName': specializationName,
      'photo': photo,
      'day': day,
      'time': time,
      'address': address,
    };
  }

  GetAllBooking copyWith({
    int? id,
    int? doctorId,
    int? bookingId,
    String? doctorName,
    String? specializationName,
    String? photo,
    String? day,
    String? time,
    String? address,
  }) {
    return GetAllBooking(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      bookingId: bookingId ?? this.bookingId,
      doctorName: doctorName ?? this.doctorName,
      specializationName: specializationName ?? this.specializationName,
      photo: photo ?? this.photo,
      day: day ?? this.day,
      time: time ?? this.time,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'GetAllBooking(id: $id, doctorId: $doctorId, bookingId: $bookingId, doctorName: $doctorName, specializationName: $specializationName, photo: $photo, day: $day, time: $time, address: $address)';
  }
}
