class DoctorModel {
  final int? id;
  final String doctorName;
  final String specializationName;
  final String? photo;

  DoctorModel({
    required this.doctorName,
    required this.specializationName,
    this.photo,
    this.id,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int?,
      doctorName: json['doctorName'] as String,
      specializationName: json['specializationName'] as String,
      photo: json['photo'] as String?, // Allow null for photo
    );
  }
}
