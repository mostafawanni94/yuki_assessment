import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds a Material [ThemeData] from any [AppColorScheme].
/// Single Responsibility: theme wiring only.
abstract final class AppTheme {
  static const double radiusSmall  = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge  = 24.0;

  static ThemeData from(AppColorScheme c) {
    final isDark = _isDark(c);
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary:    c.primary,
        onPrimary:  isDark ? c.bg : Colors.white,
        secondary:  c.accent,
        onSecondary: isDark ? c.bg : Colors.white,
        surface:    c.bgCard,
        onSurface:  c.textPrimary,
        error:      c.error,
        onError:    Colors.white,
        outline:    c.border,
      ),
      scaffoldBackgroundColor: c.bg,
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        foregroundColor: c.textPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: c.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(color: c.border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: isDark ? c.bg : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium)),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
      ),
      dividerTheme: DividerThemeData(
          color: c.divider, thickness: 0.5, space: 0),
      chipTheme: ChipThemeData(
        backgroundColor: c.primaryGlow,
        side: BorderSide(color: c.primaryDim, width: 0.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall)),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge:   AppTextStyles.displayLarge(c),
        displayMedium:  AppTextStyles.displayMedium(c),
        headlineLarge:  AppTextStyles.headingLarge(c),
        headlineMedium: AppTextStyles.headingMedium(c),
        titleLarge:     AppTextStyles.headingLarge(c),
        titleMedium:    AppTextStyles.headingMedium(c),
        titleSmall:     AppTextStyles.headingSmall(c),
        bodyLarge:      AppTextStyles.bodyLarge(c),
        bodyMedium:     AppTextStyles.bodyMedium(c),
        bodySmall:      AppTextStyles.bodySmall(c),
        labelLarge:     AppTextStyles.labelLarge(c),
        labelSmall:     AppTextStyles.labelSmall(c),
      ),
    );
  }

  /// Heuristic: dark if background luminance < 0.5
  static bool _isDark(AppColorScheme c) =>
      c.bg.computeLuminance() < 0.5;
}

extension BuildContextTheme on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get cs => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
