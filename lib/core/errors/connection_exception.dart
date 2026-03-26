import 'base_exception.dart';

class ConnectionException extends BaseException {
  const ConnectionException();

  @override
  String toString() => 'No internet connection';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is ConnectionException;

  @override
  int get hashCode => super.hashCode;
}
