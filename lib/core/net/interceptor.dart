import 'package:dio/dio.dart';

/// Logging interceptor for debug builds.
/// SWAPI is public — no auth headers needed.
/// Structure preserved so auth can be added for future APIs.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[REQ] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('[RES] ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[ERR] ${err.message} ${err.requestOptions.uri}');
    handler.next(err);
  }
}
