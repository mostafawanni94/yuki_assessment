import 'package:dio/dio.dart';

/// Central Dio configuration.
/// Single Responsibility: base options only — no interceptors here.
abstract final class DioConfig {
  static const String _baseUrl = 'https://swapi.dev/api/';

  static BaseOptions createBaseOptions() => BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
}
