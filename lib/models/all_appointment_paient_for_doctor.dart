class AllAppointmentsPatientForDoctor {
  final int bookingId;
  final int patientId;
  final String patientName;
  final String? patientPhoto;
  final int age;

  AllAppointmentsPatientForDoctor({
    required this.bookingId,
    required this.patientId,
    required this.patientName,
    this.patientPhoto,
    required this.age,
  });

  factory AllAppointmentsPatientForDoctor.fromJson(Map<String, dynamic> json) {
    return AllAppointmentsPatientForDoctor(
      bookingId: json['bookingId'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      patientPhoto: json['patientPhoto'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'patientId': patientId,
      'patientName': patientName,
      'patientPhoto': patientPhoto,
      'age': age,
    };
  }
}
