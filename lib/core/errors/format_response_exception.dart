import 'base_exception.dart';

class FormatResponseException extends BaseException {
  const FormatResponseException([this.message]);
  final String? message;

  @override
  String toString() => message ?? 'Invalid response format';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is FormatResponseException;

  @override
  int get hashCode => super.hashCode;
}
