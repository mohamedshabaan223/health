class SignInModel {
  final String message;
  final int id;
  final TokenModel token;

  SignInModel({required this.message, required this.id, required this.token});

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      message: json['message'],
      id: json['id'],
      token: TokenModel.fromJson(json['token']),
    );
  }
}

class TokenModel {
  final String result;

  TokenModel({required this.result});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      result: json['result'],
    );
  }
}
