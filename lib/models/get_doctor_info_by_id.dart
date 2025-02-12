class GetDoctorInfoById {
  final int id;
  final String name;
  final String specialization;
  final String experience;
  final String? profileImage;
  final String? focus;
  final List<AvailableAppointment> availableAppointments;

  GetDoctorInfoById({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    this.profileImage,
    this.focus,
    required this.availableAppointments,
  });

  factory GetDoctorInfoById.fromJson(Map<String, dynamic> json) {
    return GetDoctorInfoById(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      experience: json['experience'],
      profileImage: json['profileImage'],
      focus: json['focus'],
      availableAppointments: (json['availableAppointments'] as List)
          .map((appointment) => AvailableAppointment.fromJson(appointment))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'experience': experience,
      'profileImage': profileImage,
      'focus': focus,
      'availableAppointments': availableAppointments
          .map((appointment) => appointment.toJson())
          .toList(),
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
