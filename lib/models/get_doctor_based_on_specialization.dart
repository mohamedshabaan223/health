class GetDoctorBySpecialization {
  final int id;
  final String doctorName;
  final String? photo;
  final String address;
  final int rating; // إضافة الحقل rating

  GetDoctorBySpecialization({
    required this.id,
    required this.doctorName,
    this.photo,
    required this.address,
    required this.rating, // إضافة في constructor
  });

  factory GetDoctorBySpecialization.fromJson(Map<String, dynamic> json) {
    return GetDoctorBySpecialization(
      id: json['id'] as int,
      doctorName: json['doctorName'] as String,
      photo: json['photo'] as String?,
      address: json['address'] as String,
      rating: json['rating'] as int, // معالجة الحقل rating
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'photo': photo,
      'address': address,
      'rating': rating, // تضمين الحقل rating في التصدير
    };
  }
}
