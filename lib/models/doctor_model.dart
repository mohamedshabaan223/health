class DoctorModel {
  final int? id;
  final String doctorName;
  final String specializationName;
  final String? photo;
  final String address; // تمت إضافته

  DoctorModel({
    required this.id,
    required this.doctorName,
    required this.specializationName,
    this.photo,
    required this.address, // تمت إضافته
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int?,
      doctorName: json['doctorName'] as String,
      specializationName: json['specializationName'] as String,
      photo: json['photo'] as String?,
      address: json['address'] as String, // تمت إضافته
    );
  }
}
