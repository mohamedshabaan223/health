class NearbyDoctorModel {
  final int id;
  final double latitude;
  final double longitude;
  final int userId;
  final String userRole;

  NearbyDoctorModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.userRole,
  });

  factory NearbyDoctorModel.fromJson(Map<String, dynamic> json) {
    return NearbyDoctorModel(
      id: json['id'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      userId: json['userId'],
      userRole: json['userRole'],
    );
  }
}
