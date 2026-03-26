import 'base_exception.dart';

class UnauthorizedException extends BaseException {
  const UnauthorizedException({this.message});
  final String? message;

  @override
  String toString() => message ?? 'Unauthorized';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is UnauthorizedException;

  @override
  int get hashCode => super.hashCode;
}
