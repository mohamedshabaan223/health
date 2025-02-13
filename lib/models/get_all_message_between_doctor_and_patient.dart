class GetAllMessageBetweenDoctorAndPatient {
  final int id;
  final String message;
  final DateTime sendTime;
  final int senderId;
  final int receiverId;
  final String senderType;
  final String receiverType;

  GetAllMessageBetweenDoctorAndPatient({
    required this.id,
    required this.message,
    required this.sendTime,
    required this.senderId,
    required this.receiverId,
    required this.senderType,
    required this.receiverType,
  });

  factory GetAllMessageBetweenDoctorAndPatient.fromJson(
      Map<String, dynamic> json) {
    return GetAllMessageBetweenDoctorAndPatient(
      id: json['id'],
      message: json['message'],
      sendTime: DateTime.parse(json['sendTime']),
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      senderType: json['senderType'],
      receiverType: json['receiverType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sendTime': sendTime.toIso8601String(),
      'senderId': senderId,
      'receiverId': receiverId,
      'senderType': senderType,
      'receiverType': receiverType,
    };
  }
}
