import 'package:dio/dio.dart';
import 'base_params.dart';

/// Params for use-cases that need no extra data.
class NoParams extends BaseParams {
  NoParams() : super(cancelToken: CancelToken());
}
