class GetDoctorInfoById {
  final int id;
  final String name;
  final String email;
  final String specialization;
  final String experience;
  final String? profileImage;
  final String? focus;
  final String address;
  final List<Price> prices;
  final List<AvailableAppointment> availableAppointments;

  GetDoctorInfoById({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.experience,
    this.profileImage,
    this.focus,
    required this.address,
    required this.prices,
    required this.availableAppointments,
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
      prices: (json['prices'] as List)
          .map((price) => Price.fromJson(price))
          .toList(),
      availableAppointments: (json['availableAppointments'] as List)
          .map((appointment) => AvailableAppointment.fromJson(appointment))
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
      'prices': prices.map((p) => p.toJson()).toList(),
      'availableAppointments':
          availableAppointments.map((a) => a.toJson()).toList(),
    };
  }
}

class Price {
  final String name;
  final double price;

  Price({
    required this.name,
    required this.price,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}

class AvailableAppointment {
  final int appointmentId;
  final String day;
  final String time;

  AvailableAppointment({
    required this.appointmentId,
    required this.day,
    required this.time,
  });

  factory AvailableAppointment.fromJson(Map<String, dynamic> json) {
    return AvailableAppointment(
      appointmentId: json['appointmentId'],
      day: json['day'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'day': day,
      'time': time,
    };
  }
}
