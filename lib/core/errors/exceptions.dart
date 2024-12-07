import 'package:health_app/core/errors/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;

  ServerException({required this.errorModel});

  @override
  String toString() => 'ServerException: ${errorModel.errorMessage}';
}
