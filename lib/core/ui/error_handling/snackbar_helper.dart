import 'package:flutter/material.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';
import 'package:swapi_planets/core/errors/bad_request_exception.dart';
import 'package:swapi_planets/core/errors/connection_exception.dart';
import 'package:swapi_planets/core/errors/socket_exception.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';

/// Shows error SnackBars.
/// Single Responsibility: SnackBar presentation only.
abstract final class SnackBarHelper {
  static void showError(BuildContext context, BaseException error) {
    _show(
      context,
      message: _messageFor(error),
      icon: _iconFor(error),
      color: Colors.red.shade700,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(context,
        message: message,
        icon: Icons.warning_amber_rounded,
        color: Colors.orange.shade700);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context,
        message: message,
        icon: Icons.check_circle_outline,
        color: Colors.green.shade700);
  }

  // ─── Private ─────────────────────────────────────────────────────────────

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Row(children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(message,
                  style: const TextStyle(color: Colors.white))),
        ]),
      ));
  }

  static String _messageFor(BaseException e) => switch (e) {
        BadRequestException(message: final m) => m ?? e.toString(),
        TimeoutException() => 'Request timed out. Try again.',
        ConnectionException() || SocketServerException() =>
          'No internet connection.',
        _ => e.toString(),
      };

  static IconData _iconFor(BaseException e) => switch (e) {
        TimeoutException() => Icons.access_time,
        ConnectionException() || SocketServerException() => Icons.wifi_off,
        _ => Icons.error_outline,
      };
}
