class GetDoctorBySpecialization {
  final int id;
  final String doctorName;
  final String? photo;
  final String address;

  GetDoctorBySpecialization({
    required this.id,
    required this.doctorName,
    this.photo,
    required this.address,
  });

  factory GetDoctorBySpecialization.fromJson(Map<String, dynamic> json) {
    return GetDoctorBySpecialization(
      id: json['id'] as int,
      doctorName: json['doctorName'] as String,
      photo: json['photo'] as String?,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'photo': photo,
      'address': address,
    };
  }
}
