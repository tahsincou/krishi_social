import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️ ${options.method} ${options.uri}');

    if (options.data != null) {
      debugPrint('Body: ${options.data}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ ${response.statusCode} ${response.requestOptions.uri}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ ${err.response?.statusCode} ${err.requestOptions.uri}');

    debugPrint(err.message);

    super.onError(err, handler);
  }
}
