class RegisterModel {
  final String message;
  final int id; // Changed to int since "id" is a number in the response
  final Token token;

  RegisterModel({
    required this.message,
    required this.id,
    required this.token,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message'],
      id: json['id'], // Added mapping for "id"
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
