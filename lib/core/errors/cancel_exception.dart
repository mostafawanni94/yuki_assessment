import 'base_exception.dart';

class CancelException extends BaseException {
  const CancelException();

  @override
  String toString() => 'Request cancelled';
}
