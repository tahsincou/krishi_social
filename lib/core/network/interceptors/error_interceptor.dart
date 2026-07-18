import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Something went wrong';

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;

      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;

      case DioExceptionType.receiveTimeout:
        message = 'Server timeout';
        break;

      case DioExceptionType.badResponse:
        message = 'Server error';
        break;

      default:
        message = 'Unexpected error';
    }
    debugPrint('API Error: $message');

    super.onError(err, handler);
  }
}
