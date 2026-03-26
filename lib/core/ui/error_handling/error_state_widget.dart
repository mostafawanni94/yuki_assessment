import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';
import 'package:swapi_planets/core/errors/bad_request_exception.dart';
import 'package:swapi_planets/core/errors/connection_exception.dart';
import 'package:swapi_planets/core/errors/forbidden_exception.dart';
import 'package:swapi_planets/core/errors/not_found_exception.dart';
import 'package:swapi_planets/core/errors/socket_exception.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/errors/unauthorized_exception.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';

/// Display modes for [ErrorStateWidget].
enum ErrorDisplayType { full, compact, inline, empty }

/// Immutable error display config.
class _ErrorConfig {
  const _ErrorConfig({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String message;
}

/// Universal widget for failure and empty states.
/// Single Responsibility: renders an error/empty state — nothing else.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.showRetry = true,
    this.customMessage,
    this.displayType = ErrorDisplayType.full,
  })  : isEmptyState = false,
        emptyTitle = null,
        emptyMessage = null,
        emptyIcon = null;

  const ErrorStateWidget.empty({
    super.key,
    this.onRetry,
    this.showRetry = false,
    this.customMessage,
    this.displayType = ErrorDisplayType.empty,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon,
  })  : error = null,
        isEmptyState = true;

  final BaseException? error;
  final VoidCallback? onRetry;
  final bool showRetry;
  final String? customMessage;
  final ErrorDisplayType displayType;
  final bool isEmptyState;
  final String? emptyTitle;
  final String? emptyMessage;
  final IconData? emptyIcon;

  @override
  Widget build(BuildContext context) {
    final cfg = isEmptyState ? _emptyConfig() : _errorConfig(error!);
    return switch (displayType) {
      ErrorDisplayType.compact => _Compact(
          cfg: cfg, onRetry: onRetry, showRetry: showRetry,
          customMessage: customMessage),
      ErrorDisplayType.inline => _Inline(
          cfg: cfg, onRetry: onRetry, showRetry: showRetry,
          customMessage: customMessage),
      _ => _Full(
          cfg: cfg, onRetry: onRetry, showRetry: showRetry,
          customMessage: customMessage),
    };
  }

  // ─── Config factories ─────────────────────────────────────────────────────

  _ErrorConfig _emptyConfig() => _ErrorConfig(
        icon: emptyIcon ?? Icons.inbox_outlined,
        color: Colors.grey.shade500,
        title: emptyTitle ?? 'No Data',
        message: emptyMessage ?? 'Nothing to display here yet.',
      );

  _ErrorConfig _errorConfig(BaseException e) => switch (e) {
        BadRequestException() => _ErrorConfig(
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
            title: 'Invalid Request',
            message: e.toString()),
        UnauthorizedException() => const _ErrorConfig(
            icon: Icons.lock_outline,
            color: Colors.red,
            title: 'Authentication Required',
            message: 'Please sign in to continue.'),
        ForbiddenException() => const _ErrorConfig(
            icon: Icons.block,
            color: Colors.red,
            title: 'Access Denied',
            message: 'You do not have permission.'),
        NotFoundException() => const _ErrorConfig(
            icon: Icons.search_off,
            color: Colors.blue,
            title: 'Not Found',
            message: 'The resource could not be found.'),
        TimeoutException() => const _ErrorConfig(
            icon: Icons.access_time,
            color: Colors.orange,
            title: 'Request Timeout',
            message: 'The server took too long to respond.'),
        ConnectionException() || SocketServerException() => const _ErrorConfig(
            icon: Icons.wifi_off,
            color: Colors.grey,
            title: 'No Connection',
            message: 'Check your internet connection.'),
        _ => const _ErrorConfig(
            icon: Icons.error_outline,
            color: Colors.red,
            title: 'Something Went Wrong',
            message: 'An unexpected error occurred.'),
      };
}

// ─── Private layout widgets ───────────────────────────────────────────────────

class _Full extends StatelessWidget {
  const _Full(
      {required this.cfg,
      this.onRetry,
      required this.showRetry,
      this.customMessage});
  final _ErrorConfig cfg;
  final VoidCallback? onRetry;
  final bool showRetry;
  final String? customMessage;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _IconBox(cfg: cfg),
            SizedBox(height: 24.h),
            Text(cfg.title,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: cfg.color, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            SizedBox(height: 8.h),
            Text(customMessage ?? cfg.message,
                style: context.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
            if (showRetry && onRetry != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
}

class _Compact extends StatelessWidget {
  const _Compact(
      {required this.cfg,
      this.onRetry,
      required this.showRetry,
      this.customMessage});
  final _ErrorConfig cfg;
  final VoidCallback? onRetry;
  final bool showRetry;
  final String? customMessage;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cfg.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border:
              Border.all(color: cfg.color.withOpacity(0.2)),
        ),
        child: Row(children: [
          Icon(cfg.icon, color: cfg.color, size: 24),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(customMessage ?? cfg.message,
                style: context.textTheme.bodySmall
                    ?.copyWith(color: cfg.color),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
          if (showRetry && onRetry != null)
            IconButton(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: 20, color: cfg.color)),
        ]),
      );
}

class _Inline extends StatelessWidget {
  const _Inline(
      {required this.cfg,
      this.onRetry,
      required this.showRetry,
      this.customMessage});
  final _ErrorConfig cfg;
  final VoidCallback? onRetry;
  final bool showRetry;
  final String? customMessage;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(cfg.icon, size: 16, color: cfg.color),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(customMessage ?? cfg.message,
              style: context.textTheme.bodySmall?.copyWith(color: cfg.color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        if (showRetry && onRetry != null)
          GestureDetector(
              onTap: onRetry,
              child: Icon(Icons.refresh, size: 16, color: cfg.color)),
      ]);
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.cfg});
  final _ErrorConfig cfg;

  @override
  Widget build(BuildContext context) => Container(
        width: 72.r,
        height: 72.r,
        decoration: BoxDecoration(
          color: cfg.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: cfg.color.withOpacity(0.2), width: 2),
        ),
        child: Icon(cfg.icon, size: 36, color: cfg.color),
      );
}
