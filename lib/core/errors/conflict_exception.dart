import 'base_exception.dart';

class ConflictException extends BaseException {
  const ConflictException({this.message});
  final String? message;

  @override
  String toString() => message ?? 'Conflict error';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is ConflictException;

  @override
  int get hashCode => super.hashCode;
}
