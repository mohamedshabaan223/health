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
      price: json['price'] as int?,
    );
  }
}

class DoctorModelForNearByDoctor {
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

  DoctorModelForNearByDoctor({
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

  factory DoctorModelForNearByDoctor.fromJson(Map<String, dynamic> json) {
    return DoctorModelForNearByDoctor(
      id: json['id'] as int?,
      doctorName: json['name'] as String,
      email: json['email'] as String,
      specializationName: json['specialization'] as String,
      experience: json['experience'] as String,
      photo: json['profileImage'] as String?,
      phone: json['focus'] as String?,
      address: json['address'] as String,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      availableSlots: (json['availableSlots'] as List<dynamic>?)
              ?.map((slot) =>
                  AvailableSlotModel.fromJson(slot as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
