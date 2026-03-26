import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// App-wide Material theme builder.
/// Single Responsibility: theme wiring only — colors/styles in AppColors/AppTextStyles.
abstract final class AppTheme {
  // Expose constants needed by other widgets
  static const double radiusSmall  = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge  = 24.0;

  static ThemeData dark() => _build();

  static ThemeData _build() {
    const cs = ColorScheme.dark(
      primary:    AppColors.gold,
      onPrimary:  AppColors.bg,
      secondary:  AppColors.saberBlue,
      onSecondary: AppColors.bg,
      surface:    AppColors.bgCard,
      onSurface:  AppColors.textPrimary,
      error:      AppColors.error,
      onError:    Colors.white,
      outline:    AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.bg,
      // Status bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.displayMedium,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.bg,
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.bg, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.gold),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.goldGlow,
        labelStyle: AppTextStyles.chip,
        side: const BorderSide(color: AppColors.goldDim, width: 0.5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall)),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge:  AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        titleLarge:    AppTextStyles.headingLarge,
        titleMedium:   AppTextStyles.headingMedium,
        titleSmall:    AppTextStyles.headingSmall,
        bodyLarge:     AppTextStyles.bodyLarge,
        bodyMedium:    AppTextStyles.bodyMedium,
        bodySmall:     AppTextStyles.bodySmall,
        labelLarge:    AppTextStyles.labelLarge,
        labelSmall:    AppTextStyles.labelSmall,
      ),
    );
  }
}

extension BuildContextTheme on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
