import 'package:dio/dio.dart';
import 'package:flutter_mvp_starter/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_mvp_starter/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_mvp_starter/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_mvp_starter/core/storage/secure_storage_service.dart';
import '../config/app_config.dart';

class DioClient {
  final SecureStorageService secureStorage;

  DioClient(this.secureStorage);

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
