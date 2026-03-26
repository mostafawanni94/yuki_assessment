import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';

part 'result.freezed.dart';

/// Sealed result type — avoids throwing exceptions across layers.
@Freezed(genericArgumentFactories: true)
sealed class MyResult<T> with _$MyResult<T> {
  const factory MyResult.isSuccess([T? model]) = IsSuccess<T>;
  const factory MyResult.isError(BaseException error) = IsError<T>;
}
