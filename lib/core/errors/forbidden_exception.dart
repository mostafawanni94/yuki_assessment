import 'base_exception.dart';

class ForbiddenException extends BaseException {
  const ForbiddenException();

  @override
  String toString() => 'Access denied';
}
