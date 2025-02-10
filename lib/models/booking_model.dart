class BookingRequest {
  final int doctorId;
  final String day;
  final String time;
  final String? patientName;
  final String gender;
  final int age;
  final bool forHimSelf;
  final int patientId;
  final String problemDescription;

  BookingRequest({
    required this.doctorId,
    required this.day,
    required this.time,
    this.patientName,
    required this.gender,
    required this.age,
    required this.forHimSelf,
    required this.patientId,
    required this.problemDescription,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "doctorId": doctorId,
      "day": day,
      "time": time,
      "gender": gender,
      "age": age,
      "forHimSelf": forHimSelf,
      "patientId": patientId,
      "problemDescription": problemDescription,
    };
    if (!forHimSelf && patientName != null) {
      data["patientName"] = patientName!;
    }

    return data;
  }
}

class BookingResponse {
  final String message;
  final int bookingId;
  final BookingRequest? data;

  BookingResponse({
    required this.message,
    required this.bookingId,
    this.data,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      message: json["message"] ?? "No message",
      bookingId: json["bookingId"] ?? 0,
      data: json["data"] != null
          ? BookingRequest(
              doctorId: json["data"]["doctorId"] ?? 0,
              day: json["data"]["day"] ?? "",
              time: json["data"]["time"] ?? "",
              patientName: json["data"]["patientName"],
              gender: json["data"]["gender"] ?? "Unknown",
              age: json["data"]["age"] ?? 0,
              forHimSelf: json["data"]["forHimSelf"] ?? true,
              patientId: json["data"]["patientId"] ?? 0,
              problemDescription: json["data"]["problemDescription"] ?? "",
            )
          : null,
    );
  }
}
