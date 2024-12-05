class SignInModel {
  final String message;
  final String token;

  SignInModel({required this.message, required this.token});

  factory SignInModel.fromJson(json) {
    return SignInModel(message: json["message"], token: json["token"]);
  }
}
