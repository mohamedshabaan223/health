class AvailableSlotModel {
  final String day;
  final String name;
  final String timeStart;
  final String timeEnd;
  final int appointmentId;
  final int? price;

  AvailableSlotModel({
    required this.day,
    required this.name,
    required this.timeStart,
    required this.timeEnd,
    required this.appointmentId,
    required this.price,
  });

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotModel(
      day: json['day'] as String,
      name: json['name'] as String,
      timeStart: json['timeStart'] as String,
      timeEnd: json['timeEnd'] as String,
      appointmentId: json['appointmentId'] as int,
      price: json['price'] as int?, // ✅ هنا التعديل
    );
  }
}

class DoctorModel {
  final int? id;
  final String doctorName;
  final String specializationName;
  final String? photo;
  final String address;
  final String experience;
  final String email;
  final String? phone;
  final double rating;
  String? localImagePath;
  final List<AvailableSlotModel> availableSlots;

  DoctorModel({
    required this.id,
    required this.doctorName,
    required this.specializationName,
    this.photo,
    required this.address,
    required this.experience,
    required this.email,
    this.phone,
    required this.rating,
    this.localImagePath,
    required this.availableSlots,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int?,
      doctorName: json['doctorName'] as String,
      specializationName: json['specializationName'] as String,
      photo: json['photo'] as String?,
      address: json['address'] as String,
      experience: json['experience'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      rating: (json['rating'] as num).toDouble(),
      availableSlots: (json['availableSlots'] as List<dynamic>?)
              ?.map((slot) =>
                  AvailableSlotModel.fromJson(slot as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
