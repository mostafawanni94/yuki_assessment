/// Base class for all domain exceptions.
/// Const-correct: immutable hierarchy.
abstract class BaseException {
  const BaseException();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseException && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
