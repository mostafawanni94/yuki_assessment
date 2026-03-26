import 'dart:io' show SocketException;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show compute, kDebugMode;
import 'package:swapi_planets/core/errors/bad_request_exception.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';
import 'package:swapi_planets/core/errors/cancel_exception.dart';
import 'package:swapi_planets/core/errors/conflict_exception.dart';
import 'package:swapi_planets/core/errors/forbidden_exception.dart';
import 'package:swapi_planets/core/errors/format_response_exception.dart';
import 'package:swapi_planets/core/errors/internal_server_exception.dart';
import 'package:swapi_planets/core/errors/not_found_exception.dart';
import 'package:swapi_planets/core/errors/socket_exception.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/errors/unauthorized_exception.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/net/http_method.dart';
import 'package:swapi_planets/core/result/result.dart';

/// Low-level HTTP client wrapper.
///
/// Single Responsibility: execute requests + map errors to domain exceptions.
/// DRY: all Dio error mapping lives in [_handleDioError].
class ApiClient {
  ApiClient(this._dio, {int largeResponseThreshold = 10 * 1024})
      : _largeResponseThreshold = largeResponseThreshold;

  final Dio _dio;
  final int _largeResponseThreshold;

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Generic GET / POST / PUT / DELETE.
  Future<MyResult<T>> request<T>({
    required T Function(dynamic) converter,
    required HttpMethod method,
    required String url,
    required CancelToken cancelToken,
    Map<String, String>? headers,
    dynamic queryParameters,
    dynamic body,
  }) async {
    try {
      final response = await _executeRequest(
        method: method,
        url: url,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
        cancelToken: cancelToken,
      );
      return _processResponse(response, converter);
    } on FormatException {
      return IsError(
          const FormatResponseException('Format exception'));
    } on DioException catch (e) {
      return IsError(_handleDioError(e));
    } catch (_) {
      return const IsError(UnknownException());
    }
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  Future<Response> _executeRequest({
    required HttpMethod method,
    required String url,
    required dynamic body,
    required dynamic queryParameters,
    required Map<String, String>? headers,
    required CancelToken cancelToken,
  }) {
    final options = Options(headers: headers);
    return switch (method) {
      HttpMethod.GET => _dio.get(url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken),
      HttpMethod.POST => _dio.post(url,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken),
      HttpMethod.PUT => _dio.put(url,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken),
      HttpMethod.DELETE => _dio.delete(url,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken),
    };
  }

  /// Handles both paginated SWAPI envelopes `{count, results:[]}` and
  /// direct objects `{name, ...}`.
  Future<MyResult<T>> _processResponse<T>(
    Response response,
    T Function(dynamic) converter,
  ) async {
    try {
      final data = response.data;
      if (data == null) {
        return IsError(
            FormatResponseException('Empty response'));
      }
      return _convert(data: data, converter: converter);
    } catch (e) {
      if (kDebugMode) print('[ApiClient] process error: $e');
      return IsError(FormatResponseException('$e'));
    }
  }

  Future<MyResult<T>> _convert<T>({
    required dynamic data,
    required T Function(dynamic) converter,
  }) async {
    try {
      final bool useCompute = data is List &&
          data.toString().length > _largeResponseThreshold;
      final result =
          useCompute ? await compute(converter, data) : converter(data);
      return IsSuccess(result);
    } catch (e) {
      if (kDebugMode) print('[ApiClient] convert error: $e');
      return IsError(FormatResponseException('Conversion failed: $e'));
    }
  }

  /// Maps every Dio error variant to a typed domain exception.
  BaseException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const TimeoutException();
    }
    if (e.type == DioExceptionType.cancel) return const CancelException();
    if (e.error is SocketException) return const SocketServerException();

    final status = e.response?.statusCode;
    final msg = _extractMessage(e.response?.data);

    return switch (status) {
      400 || 422 => BadRequestException(message: msg),
      401 => UnauthorizedException(message: msg),
      403 => const ForbiddenException(),
      404 => const NotFoundException(),
      409 => ConflictException(message: msg),
      500 => InternalServerException(message: msg),
      _ => const UnknownException(),
    };
  }

  String? _extractMessage(dynamic data) {
    if (data is! Map) return null;
    if (data['message'] != null) return data['message'].toString();
    final errors = data['errors'];
    if (errors is Map) {
      for (final v in errors.values) {
        if (v is List && v.isNotEmpty) return v.first.toString();
        if (v != null) return v.toString();
      }
    }
    return null;
  }
}
