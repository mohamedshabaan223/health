class PriceModel {
  final String name;
  final int price;

  PriceModel({
    required this.name,
    required this.price,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      name: json['name'] as String,
      price: json['price'] as int,
    );
  }
}

class DoctorModel {
  final int? id;
  final String doctorName;
  final String specializationName;
  final String? photo;
  final String address;
  final String experience;
  final String email;
  final String? phone;
  final double rating;
  final List<PriceModel> prices;

  DoctorModel({
    required this.id,
    required this.doctorName,
    required this.specializationName,
    this.photo,
    required this.address,
    required this.experience,
    required this.email,
    this.phone,
    required this.rating,
    required this.prices,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int?,
      doctorName: json['doctorName'] as String,
      specializationName: json['specializationName'] as String,
      photo: json['photo'] as String?,
      address: json['address'] as String,
      experience: json['experience'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      rating: (json['rating'] as num).toDouble(),
      prices: (json['prices'] as List<dynamic>)
          .map((price) => PriceModel.fromJson(price as Map<String, dynamic>))
          .toList(),
    );
  }
}
