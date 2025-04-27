class GetDoctorInfoById {
  final int id;
  final String name;
  final String email;
  final String specialization;
  final String experience;
  final String? profileImage;
  final String? focus;
  final String address;
  final double rating;
  String? localImagePath;

  final List<AvailableSlot> availableSlots;

  GetDoctorInfoById({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.experience,
    this.profileImage,
    this.focus,
    required this.address,
    required this.rating,
    String? localImagePath,
    required this.availableSlots,
  });

  factory GetDoctorInfoById.fromJson(Map<String, dynamic> json) {
    return GetDoctorInfoById(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      specialization: json['specialization'],
      experience: json['experience'],
      profileImage: json['profileImage'],
      focus: json['focus'],
      address: json['address'],
      rating: (json['rating'] as num).toDouble(),
      availableSlots: (json['availableSlots'] as List)
          .map((slot) => AvailableSlot.fromJson(slot))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'specialization': specialization,
      'experience': experience,
      'profileImage': profileImage,
      'focus': focus,
      'address': address,
      'rating': rating,
      'availableSlots': availableSlots.map((slot) => slot.toJson()).toList(),
    };
  }
}

class AvailableSlot {
  final String day;
  final String name;
  final String timeStart;
  final String timeEnd;
  final int appointmentId;
  final double price;

  AvailableSlot({
    required this.day,
    required this.name,
    required this.timeStart,
    required this.timeEnd,
    required this.appointmentId,
    required this.price,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      day: json['day'],
      name: json['name'],
      timeStart: json['timeStart'],
      timeEnd: json['timeEnd'],
      appointmentId: json['appointmentId'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'name': name,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'appointmentId': appointmentId,
      'price': price,
    };
  }
}
