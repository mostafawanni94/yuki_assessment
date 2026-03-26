import 'base_exception.dart';

class UnknownException extends BaseException {
  const UnknownException();

  @override
  String toString() => 'An unexpected error occurred';
}
