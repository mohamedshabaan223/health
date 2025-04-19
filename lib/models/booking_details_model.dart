class BookingDetailsModel {
  final int patientId;
  final String patientName;
  final String? patientPhoto;
  final int age;
  final String day;
  final String time;
  final String phone;
  final String gender;
  final String problemDescription;

  BookingDetailsModel({
    required this.patientId,
    required this.patientName,
    this.patientPhoto,
    required this.age,
    required this.day,
    required this.time,
    required this.phone,
    required this.gender,
    required this.problemDescription,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      patientId: json['patientId'],
      patientName: json['patientName'],
      patientPhoto: json['patientPhoto'],
      age: json['age'],
      day: json['day'],
      time: json['time'],
      phone: json['phone'],
      gender: json['gender'],
      problemDescription: json['problemDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'patientName': patientName,
      'patientPhoto': patientPhoto,
      'age': age,
      'day': day,
      'time': time,
      'phone': phone,
      'gender': gender,
      'problemDescription': problemDescription,
    };
  }
}
