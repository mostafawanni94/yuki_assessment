import 'package:swapi_planets/core/result/result.dart';

/// Base contract for all use cases with input parameters.
///
/// Single Responsibility: defines one business operation.
/// DRY: BLoC always calls execute() — never touches repository directly.
///
/// [O] = output type
/// [I] = input / params type
abstract interface class UseCase<O, I> {
  Future<MyResult<O>> execute(I params);
}

/// Use case with no input — just execute.
abstract interface class NoParamsUseCase<O> {
  Future<MyResult<O>> execute();
}
