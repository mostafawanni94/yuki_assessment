import 'base_exception.dart';

class InternalServerException extends BaseException {
  const InternalServerException({this.message});
  final String? message;

  @override
  String toString() => message ?? 'Internal server error';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is InternalServerException;

  @override
  int get hashCode => super.hashCode;
}
