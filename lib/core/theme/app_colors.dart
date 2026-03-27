import 'package:flutter/material.dart';

/// Color tokens — one set per theme.
/// Add a new theme by creating another [AppColorScheme] constant below.
class AppColorScheme {
  const AppColorScheme({
    required this.name,
    required this.bg,
    required this.bgCard,
    required this.bgCardLight,
    required this.bgOverlay,
    required this.primary,
    required this.primaryDim,
    required this.primaryGlow,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.divider,
    required this.border,
    required this.error,
    required this.warning,
    required this.planetGradients,
  });

  final String name;
  final Color bg;
  final Color bgCard;
  final Color bgCardLight;
  final Color bgOverlay;
  final Color primary;        // gold / teal / etc.
  final Color primaryDim;
  final Color primaryGlow;    // 20% alpha version
  final Color accent;         // saber blue / etc.
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color divider;
  final Color border;
  final Color error;
  final Color warning;
  final List<List<Color>> planetGradients;

  List<Color> planetGradientAt(int index) =>
      planetGradients[index % planetGradients.length];
}

// ─── Theme 1: Space (dark, Star Wars gold) ────────────────────────────────────
const AppColorScheme spaceTheme = AppColorScheme(
  name: 'Space',
  bg:           Color(0xFF080B14),
  bgCard:       Color(0xFF0F1629),
  bgCardLight:  Color(0xFF162038),
  bgOverlay:    Color(0xFF1C2A45),
  primary:      Color(0xFFE8B84B),
  primaryDim:   Color(0xFFAD8930),
  primaryGlow:  Color(0x33E8B84B),
  accent:       Color(0xFF4FC3F7),
  textPrimary:  Color(0xFFF0E6D3),
  textSecondary:Color(0xFF8A99B5),
  textMuted:    Color(0xFF4A5568),
  divider:      Color(0xFF1E2D47),
  border:       Color(0xFF253550),
  error:        Color(0xFFE53935),
  warning:      Color(0xFFFFA726),
  planetGradients: [
    [Color(0xFFE8B84B), Color(0xFFC17F24)],
    [Color(0xFF4FC3F7), Color(0xFF0277BD)],
    [Color(0xFF66BB6A), Color(0xFF2E7D32)],
    [Color(0xFFEF5350), Color(0xFF8B0000)],
    [Color(0xFF7E57C2), Color(0xFF4527A0)],
    [Color(0xFF26C6DA), Color(0xFF006064)],
    [Color(0xFFFF7043), Color(0xFFBF360C)],
    [Color(0xFF78909C), Color(0xFF37474F)],
  ],
);

// ─── Theme 2: Light (clean, minimal) ─────────────────────────────────────────
const AppColorScheme lightTheme = AppColorScheme(
  name: 'Light',
  bg:           Color(0xFFF5F7FA),
  bgCard:       Color(0xFFFFFFFF),
  bgCardLight:  Color(0xFFF0F4FF),
  bgOverlay:    Color(0xFFE8EDF5),
  primary:      Color(0xFF1A73E8),
  primaryDim:   Color(0xFF1557B0),
  primaryGlow:  Color(0x221A73E8),
  accent:       Color(0xFF00897B),
  textPrimary:  Color(0xFF1A1A2E),
  textSecondary:Color(0xFF5F6B7C),
  textMuted:    Color(0xFFADB5BD),
  divider:      Color(0xFFE2E8F0),
  border:       Color(0xFFCBD5E0),
  error:        Color(0xFFE53935),
  warning:      Color(0xFFFFA726),
  planetGradients: [
    [Color(0xFFFFB300), Color(0xFFFF6F00)],
    [Color(0xFF1A73E8), Color(0xFF0D47A1)],
    [Color(0xFF43A047), Color(0xFF1B5E20)],
    [Color(0xFFE53935), Color(0xFFB71C1C)],
    [Color(0xFF8E24AA), Color(0xFF4A148C)],
    [Color(0xFF00ACC1), Color(0xFF006064)],
    [Color(0xFFFF7043), Color(0xFFBF360C)],
    [Color(0xFF546E7A), Color(0xFF263238)],
  ],
);

// ─── Theme 3: Sith (red/dark) ─────────────────────────────────────────────────
const AppColorScheme sithTheme = AppColorScheme(
  name: 'Sith',
  bg:           Color(0xFF0D0000),
  bgCard:       Color(0xFF1A0505),
  bgCardLight:  Color(0xFF2D0A0A),
  bgOverlay:    Color(0xFF3D1010),
  primary:      Color(0xFFE53935),
  primaryDim:   Color(0xFFB71C1C),
  primaryGlow:  Color(0x33E53935),
  accent:       Color(0xFFFF8A65),
  textPrimary:  Color(0xFFF5E0E0),
  textSecondary:Color(0xFFAA7070),
  textMuted:    Color(0xFF663333),
  divider:      Color(0xFF2D0A0A),
  border:       Color(0xFF4D1515),
  error:        Color(0xFFFF1744),
  warning:      Color(0xFFFF6D00),
  planetGradients: [
    [Color(0xFFE53935), Color(0xFF8B0000)],
    [Color(0xFFFF7043), Color(0xFFBF360C)],
    [Color(0xFFEF9A9A), Color(0xFFC62828)],
    [Color(0xFFFF5252), Color(0xFFB71C1C)],
    [Color(0xFFFF8A65), Color(0xFFE64A19)],
    [Color(0xFFFFCC02), Color(0xFFF57F17)],
    [Color(0xFFD500F9), Color(0xFF6A0080)],
    [Color(0xFF78909C), Color(0xFF37474F)],
  ],
);

// ─── Available themes list — add new themes here ──────────────────────────────
const List<AppColorScheme> availableThemes = [
  spaceTheme,
  lightTheme,
  sithTheme,
];

/// Convenience — keep a reference named AppColors pointing to active theme.
/// Updated by ThemeCubit.
class AppColors {
  AppColors._();
  static AppColorScheme current = spaceTheme;
}
