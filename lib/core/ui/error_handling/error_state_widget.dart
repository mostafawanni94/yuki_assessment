import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';
import 'package:swapi_planets/core/errors/connection_exception.dart';
import 'package:swapi_planets/core/errors/socket_exception.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/l10n/app_strings.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/app_text_styles.dart';

enum ErrorDisplayType { full, compact, inline, empty }

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
    final cfg = isEmptyState ? _emptyConfig() : _errorConfig(error);
    return switch (displayType) {
      ErrorDisplayType.compact => _CompactError(
          cfg: cfg, onRetry: onRetry,
          showRetry: showRetry, customMessage: customMessage),
      ErrorDisplayType.inline => _InlineError(
          cfg: cfg, onRetry: onRetry,
          showRetry: showRetry, customMessage: customMessage),
      _ => _FullError(
          cfg: cfg, onRetry: onRetry,
          showRetry: showRetry, customMessage: customMessage),
    };
  }

  // Null-safe — never crashes even if error is null
  _ErrConfig _emptyConfig() => _ErrConfig(
        icon: emptyIcon ?? Icons.public_off_outlined,
        color: AppColors.textSecondary,
        title: emptyTitle ?? AppStrings.emptyPlanets,
        message: emptyMessage ?? AppStrings.emptyPlanetsMsg,
      );

  _ErrConfig _errorConfig(BaseException? e) {
    if (e == null) {
      return const _ErrConfig(
        icon: Icons.error_outline_rounded,
        color: AppColors.saberRed,
        title: AppStrings.errorTitle,
        message: AppStrings.errorUnknown,
      );
    }
    return switch (e) {
      TimeoutException() => const _ErrConfig(
          icon: Icons.access_time_rounded,
          color: AppColors.warning,
          title: AppStrings.errorTitle,
          message: AppStrings.errorTimeout),
      ConnectionException() || SocketServerException() => const _ErrConfig(
          icon: Icons.wifi_off_rounded,
          color: AppColors.saberBlue,
          title: AppStrings.errorTitle,
          message: AppStrings.errorNoConnection),
      _ => _ErrConfig(
          icon: Icons.error_outline_rounded,
          color: AppColors.saberRed,
          title: AppStrings.errorTitle,
          message: e.toString()),
    };
  }
}

class _ErrConfig {
  const _ErrConfig({
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

class _FullError extends StatelessWidget {
  const _FullError({required this.cfg, this.onRetry,
      required this.showRetry, this.customMessage});
  final _ErrConfig cfg;
  final VoidCallback? onRetry;
  final bool showRetry;
  final String? customMessage;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.r, height: 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cfg.color.withOpacity(0.15),
                border: Border.all(color: cfg.color.withOpacity(0.4), width: 1.5),
              ),
              child: Icon(cfg.icon, size: 36.r, color: cfg.color),
            ),
            SizedBox(height: 24.h),
            Text(cfg.title,
                style: AppTextStyles.headingLarge,
                textAlign: TextAlign.center),
            SizedBox(height: 8.h),
            Text(customMessage ?? cfg.message,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center, maxLines: 3),
            if (showRetry && onRetry != null) ...[
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(AppStrings.retryButton),
              ),
            ],
          ],
        ),
      );
}

class _CompactError extends StatelessWidget {
  const _CompactError({required this.cfg, this.onRetry,
      required this.showRetry, this.customMessage});
  final _ErrConfig cfg;
  final VoidCallback? onRetry;
  final bool showRetry;
  final String? customMessage;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: cfg.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cfg.color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(cfg.icon, color: cfg.color, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(child: Text(customMessage ?? cfg.message,
              style: AppTextStyles.bodySmall.copyWith(color: cfg.color),
              maxLines: 2)),
          if (showRetry && onRetry != null)
            IconButton(
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded, color: cfg.color, size: 18.r),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 32.r, minHeight: 32.r)),
        ]),
      );
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.cfg, this.onRetry,
      required this.showRetry, this.customMessage});
  final _ErrConfig cfg;
  final VoidCallback? onRetry;
  final bool showRetry;
  final String? customMessage;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(cfg.icon, size: 14.r, color: cfg.color),
        SizedBox(width: 6.w),
        Expanded(child: Text(customMessage ?? cfg.message,
            style: AppTextStyles.bodySmall.copyWith(color: cfg.color),
            maxLines: 1, overflow: TextOverflow.ellipsis)),
        if (showRetry && onRetry != null)
          GestureDetector(
              onTap: onRetry,
              child: Icon(Icons.refresh_rounded, size: 14.r, color: cfg.color)),
      ]);
}
