import 'package:dio/dio.dart';

/// Base for all request parameter objects.
abstract class BaseParams {
  const BaseParams({required this.cancelToken, this.id});
  final CancelToken cancelToken;
  final int? id;
}
