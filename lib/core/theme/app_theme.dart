import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide theme constants and builders.
/// Single Responsibility: theme configuration only.
abstract final class AppTheme {
  // ─── Palette ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A1A2E);
  static const Color secondary = Color(0xFF16213E);
  static const Color accent = Color(0xFF0F3460);
  static const Color highlight = Color(0xFFE94560);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color onSurface = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFCF6679);

  // ─── Radii ────────────────────────────────────────────────────────────────
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;

  // ─── Theme builders ───────────────────────────────────────────────────────
  static ThemeData light() => _build(brightness: Brightness.light);
  static ThemeData dark() => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF5F5F5);
    final text = isDark ? onSurface : primary;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: highlight,
        onPrimary: Colors.white,
        secondary: accent,
        onSecondary: Colors.white,
        surface: isDark ? surface : Colors.white,
        onSurface: text,
        error: error,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: text,
        displayColor: text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? surface : Colors.white,
        foregroundColor: isDark ? onSurface : primary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: isDark ? const Color(0xFF16213E) : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highlight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium)),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      dividerTheme: DividerThemeData(
          color: text.withOpacity(0.12), thickness: 1),
    );
  }
}

extension BuildContextTheme on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
