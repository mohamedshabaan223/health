class ErrorModel {
  final int status; // Status code (e.g., 400, 404, etc.)
  final String
      errorMessage; // The error message (e.g., "Password Is Not Correct")

  ErrorModel({required this.status, required this.errorMessage});

  // Factory constructor to create an ErrorModel from JSON response
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      status: json['status'] ?? 0, // Default to 0 if no status
      errorMessage: json['errorMessage'] ??
          'An unknown error occurred', // Default message
    );
  }

  @override
  String toString() {
    return 'ErrorModel(status: $status, errorMessage: $errorMessage)';
  }
}
