import 'base_exception.dart';

class NotFoundException extends BaseException {
  const NotFoundException();

  @override
  String toString() => 'Resource not found';
}
