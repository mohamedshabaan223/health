class ReviewModel {
  final String comment;
  final String senderName;
  final String? senderImage;
  final int rating;
  final int age;
  ReviewModel({
    required this.comment,
    required this.senderName,
    this.senderImage,
    required this.rating,
    required this.age,
  });
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      comment: json['comment'] ?? '',
      senderName: json['senderName'] ?? '',
      senderImage: json['senderImage'],
      rating: json['rating'] ?? 0,
      age: json['age'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'senderName': senderName,
      'senderImage': senderImage,
      'rating': rating,
      'age': age,
    };
  }
}
