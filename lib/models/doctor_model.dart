class DoctorModel {
  final String doctorName;
  final String specializationName;
  final String? photo;

  DoctorModel(
      {required this.doctorName, required this.specializationName, this.photo});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorName: json['doctorName'] as String,
      specializationName: json['specializationName'] as String,
      photo: json['photo'] as String?, // Allow null for photo
    );
  }
}
