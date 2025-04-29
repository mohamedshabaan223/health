class ChatSummary {
  final int id;
  final String? message;
  final String otherUserName;
  final int otherUserId;
  final String? otherUserImage; // Base64 جاي من API
  final DateTime sendTime;
  final String? image; // لو كانت الرسالة صورة
  String? localImagePath; // مسار الصورة لو كانت الرسالة صورة
  String? otherUserLocalImagePath; // مسار صورة المرسل

  ChatSummary({
    required this.id,
    this.message,
    required this.otherUserName,
    required this.otherUserId,
    required this.sendTime,
    this.image,
    this.otherUserImage,
    this.localImagePath,
    this.otherUserLocalImagePath,
  });

  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    return ChatSummary(
      id: json['id'],
      message: json['message'],
      otherUserName: json['otherUserName'],
      otherUserId: json['otherUserId'],
      sendTime: DateTime.parse(json['sendTime']),
      image: json['image'],
      otherUserImage: json['otherUserImage'],
      otherUserLocalImagePath: json['otherUserLocalImagePath'],
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
      'otherUserImage': otherUserImage,
      'otherUserLocalImagePath': otherUserLocalImagePath,
    };
  }
}
