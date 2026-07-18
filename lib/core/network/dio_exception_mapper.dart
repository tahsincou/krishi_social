import 'package:dio/dio.dart';

import '../error/app_exception.dart';

class DioExceptionMapper {
  static AppException map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const AppException('Connection timeout');

      case DioExceptionType.receiveTimeout:
        return const AppException('Server timeout');

      case DioExceptionType.connectionError:
        return const AppException('No internet connection');

      case DioExceptionType.badResponse:
        return AppException(e.response?.statusMessage ?? 'Server error');

      default:
        return const AppException('Something went wrong');
    }
  }
}
