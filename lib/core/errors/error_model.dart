class ErrorModel {
  final int status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      status: json['status'] ?? 0,
      errorMessage: json['errorMessage'] ?? 'An unknown error occurred',
    );
  }

  @override
  String toString() {
    return 'ErrorModel(status: $status, errorMessage: $errorMessage)';
  }
}
