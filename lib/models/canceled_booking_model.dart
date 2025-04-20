class CanceledBookingModel {
  final String doctorName;
  final String? doctorImage;
  final DateTime bookingDate;

  CanceledBookingModel({
    required this.doctorName,
    this.doctorImage,
    required this.bookingDate,
  });

  factory CanceledBookingModel.fromJson(Map<String, dynamic> json) {
    return CanceledBookingModel(
      doctorName: json['doctorName'],
      doctorImage: json['doctorImage'],
      bookingDate: DateTime.parse(json['bookingDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'bookingDate': bookingDate.toIso8601String(),
    };
  }
}
