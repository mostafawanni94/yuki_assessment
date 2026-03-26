import 'base_exception.dart';

class TimeoutException extends BaseException {
  const TimeoutException();

  @override
  String toString() => 'Request timed out';
}
