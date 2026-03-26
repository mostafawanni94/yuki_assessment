import 'base_exception.dart';

/// Generic exception with a developer-supplied message.
class CustomException extends BaseException {
  const CustomException({required this.message});
  final String message;

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is CustomException;

  @override
  int get hashCode => super.hashCode;
}
