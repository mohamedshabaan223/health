class UserProfile {
  final String name;
  final String? photoData;

  UserProfile({required this.name, this.photoData});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      photoData: json['photoData'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photoData': photoData,
    };
  }
}
