import 'package:swapi_planets/core/errors/base_exception.dart';

/// Sealed result type — avoids throwing exceptions across layers.
/// Plain Dart sealed class — no code generation needed.
sealed class MyResult<T> {
  const MyResult();
}

final class IsSuccess<T> extends MyResult<T> {
  const IsSuccess([this.model]);
  final T? model;
}

final class IsError<T> extends MyResult<T> {
  const IsError(this.error);
  final BaseException error;
}
