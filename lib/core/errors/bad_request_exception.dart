import 'base_exception.dart';

class BadRequestException extends BaseException {
  const BadRequestException({this.message});
  final String? message;

  @override
  String toString() => message ?? 'Bad request';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is BadRequestException;

  @override
  int get hashCode => super.hashCode;
}
