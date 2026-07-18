import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final DioException exception;

  NetworkException(this.exception);
}
