import 'base_exception.dart';

class SocketServerException extends BaseException {
  const SocketServerException();

  @override
  String toString() => 'Socket connection error';
}
