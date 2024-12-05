import 'package:health_app/core/api/end_points.dart';

class ErrorModel {
  final int status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});

  factory ErrorModel.fromJson(json) {
    return ErrorModel(
      status: json[ApiKey.status],
      errorMessage: json[ApiKey.errorMessage],
    );
  }
}
