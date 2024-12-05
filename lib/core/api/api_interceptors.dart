import 'package:dio/dio.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }
}
