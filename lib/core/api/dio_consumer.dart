import 'package:dio/dio.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/api_interceptors.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/error_model.dart';
import 'package:health_app/core/errors/exceptions.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.interceptors.add(ApiInterceptors());
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future get(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
}

// Handle DioException and throw ServerException
ServerException _handleDioException(DioException e) {
  if (e.response != null) {
    // Handle specific HTTP errors and create an ErrorModel
    switch (e.response?.statusCode) {
      case 400: // Bad Request
        // You may get the error message from the response and map it to the ErrorModel
        return ServerException(
          errorModel: ErrorModel.fromJson(e.response!.data),
        );
      case 401: // Unauthorized
        return ServerException(
          errorModel: ErrorModel.fromJson(e.response!.data),
        );
      case 500: // Internal Server Error
        return ServerException(
          errorModel: ErrorModel.fromJson(e.response!.data),
        );
      default:
        // For other status codes
        return ServerException(
          errorModel: ErrorModel(
            status: e.response?.statusCode ?? 0,
            errorMessage: 'Unexpected error occurred',
          ),
        );
    }
  } else {
    // If there is no response from the server (network error)
    return ServerException(
      errorModel: ErrorModel(
        status: 0,
        errorMessage: e.message ?? 'Network error occurred',
      ),
    );
  }
}
