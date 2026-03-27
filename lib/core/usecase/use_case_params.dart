import 'package:dio/dio.dart';

/// Base for all use case param objects.
/// Carries a CancelToken so every network use case can be cancelled.
abstract class UseCaseParams {
  UseCaseParams({CancelToken? cancelToken})
      : cancelToken = cancelToken ?? CancelToken();

  final CancelToken cancelToken;
}

/// For use cases that need no extra data beyond the cancel token.
class NoParams extends UseCaseParams {
  NoParams({super.cancelToken});
}
