class ChatSummary {
  final int id;
  final String? message;
  final String otherUserName;
  final int otherUserId;
  final DateTime sendTime;
  final String? image;

  ChatSummary({
    required this.id,
    this.message,
    required this.otherUserName,
    required this.otherUserId,
    required this.sendTime,
    this.image,
  });

  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    return ChatSummary(
      id: json['id'],
      message: json['message'],
      otherUserName: json['otherUserName'],
      otherUserId: json['otherUserId'],
      sendTime: DateTime.parse(json['sendTime']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'otherUserName': otherUserName,
      'otherUserId': otherUserId,
      'sendTime': sendTime.toIso8601String(),
      'image': image,
    };
  }
}
