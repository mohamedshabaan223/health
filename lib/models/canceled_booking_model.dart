class CanceledBookingModel {
  final String doctorName;
  final String? doctorImage;
  final String? specializationName;
  final DateTime? bookingDate;
  String? localImagePath;

  CanceledBookingModel({
    required this.doctorName,
    this.doctorImage,
    this.specializationName,
    this.bookingDate,
    this.localImagePath,
  });

  factory CanceledBookingModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['bookingDate'] != null && json['bookingDate'] != '0001-01-01') {
      parsedDate = DateTime.parse(json['bookingDate']);
    }

    return CanceledBookingModel(
      doctorName: json['doctorName'] ?? '',
      doctorImage: json['doctorImage'],
      specializationName: json['specializationName'],
      bookingDate: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'specializationName': specializationName,
      'bookingDate': bookingDate?.toIso8601String(),
    };
  }
}
