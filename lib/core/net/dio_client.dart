import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:swapi_planets/core/net/interceptor.dart';

/// Configures and exposes a single [Dio] instance.
/// Single Responsibility: wiring interceptors onto Dio.
class DioClient {
  DioClient(BaseOptions options) : _dio = Dio(options) {
    _dio.interceptors.addAll([
      LoggingInterceptor(),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
        ),
    ]);
  }

  final Dio _dio;
  Dio get dio => _dio;
}
