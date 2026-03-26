import 'package:flutter/material.dart';

/// Single source of truth for every color in the app.
/// i18n-ready: no human-readable strings here.
/// Const-correct: all values compile-time constants.
abstract final class AppColors {
  // ─── Backgrounds ─────────────────────────────────────────────────────────
  static const Color bg           = Color(0xFF080B14); // deep space
  static const Color bgCard       = Color(0xFF0F1629); // card surface
  static const Color bgCardLight  = Color(0xFF162038); // elevated card
  static const Color bgOverlay    = Color(0xFF1C2A45); // modal / sheet

  // ─── Brand ───────────────────────────────────────────────────────────────
  static const Color gold         = Color(0xFFE8B84B); // Star Wars gold
  static const Color goldDim      = Color(0xFFAD8930); // muted gold
  static const Color goldGlow     = Color(0x33E8B84B); // 20% alpha glow
  static const Color saberBlue    = Color(0xFF4FC3F7); // lightsaber blue
  static const Color saberRed     = Color(0xFFE53935); // sith red

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF0E6D3); // warm white
  static const Color textSecondary = Color(0xFF8A99B5); // muted
  static const Color textMuted     = Color(0xFF4A5568); // hint

  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error   = Color(0xFFE53935);

  // ─── Divider / border ────────────────────────────────────────────────────
  static const Color divider = Color(0xFF1E2D47);
  static const Color border  = Color(0xFF253550);

  // ─── Planet palette (cycled by index) ────────────────────────────────────
  static const List<List<Color>> planetGradients = [
    [Color(0xFFE8B84B), Color(0xFFC17F24)], // desert gold (Tatooine)
    [Color(0xFF4FC3F7), Color(0xFF0277BD)], // ocean blue (Kamino)
    [Color(0xFF66BB6A), Color(0xFF2E7D32)], // jungle green (Yavin IV)
    [Color(0xFFEF5350), Color(0xFF8B0000)], // volcanic red (Mustafar)
    [Color(0xFF7E57C2), Color(0xFF4527A0)], // nebula purple (Bespin)
    [Color(0xFF26C6DA), Color(0xFF006064)], // ice teal (Hoth)
    [Color(0xFFFF7043), Color(0xFFBF360C)], // rust orange (Geonosis)
    [Color(0xFF78909C), Color(0xFF37474F)], // steel grey (Coruscant)
  ];

  static List<Color> planetGradientAt(int index) =>
      planetGradients[index % planetGradients.length];
}
