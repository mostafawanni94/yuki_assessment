import 'package:swapi_planets/core/result/result.dart';

/// Base contract for all use cases.
/// Single Responsibility: one business operation.
/// DRY: BLoC always calls execute() — never touches repository directly.
///
/// [O] = output type
/// [I] = params type
abstract interface class UseCase<O, I> {
  Future<MyResult<O>> execute(I params);
}
