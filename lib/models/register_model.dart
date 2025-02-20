class RegisterModel {
  final String message;
  final Token token;

  RegisterModel({required this.message, required this.token});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message'],
      token: Token.fromJson(json['token']),
    );
  }
}

class Token {
  final String result;

  Token({required this.result});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      result: json['result'],
    );
  }
}
