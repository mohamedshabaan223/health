class SpecializationModel {
  final int id;
  final String name;
  final String? image;
  String imagePath = ''; // حقل لتخزين مسار الصورة المحفوظة

  SpecializationModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'imagePath': imagePath, // أضفنا المسار هنا في التعديل
    };
  }
}
