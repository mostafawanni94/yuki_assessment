import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text style factories — each takes an [AppColorScheme] so they
/// adapt to any theme automatically.
abstract final class AppTextStyles {
  static TextStyle displayLarge(AppColorScheme c) => GoogleFonts.orbitron(
        fontSize: 28.sp, fontWeight: FontWeight.w700,
        color: c.textPrimary, letterSpacing: 2);

  static TextStyle displayMedium(AppColorScheme c) => GoogleFonts.orbitron(
        fontSize: 20.sp, fontWeight: FontWeight.w600,
        color: c.textPrimary, letterSpacing: 1.5);

  static TextStyle headingLarge(AppColorScheme c) => GoogleFonts.rajdhani(
        fontSize: 22.sp, fontWeight: FontWeight.w700,
        color: c.textPrimary, letterSpacing: 0.5);

  static TextStyle headingMedium(AppColorScheme c) => GoogleFonts.rajdhani(
        fontSize: 18.sp, fontWeight: FontWeight.w600,
        color: c.textPrimary);

  static TextStyle headingSmall(AppColorScheme c) => GoogleFonts.rajdhani(
        fontSize: 14.sp, fontWeight: FontWeight.w600,
        color: c.primary, letterSpacing: 1.2);

  static TextStyle bodyLarge(AppColorScheme c) => GoogleFonts.inter(
        fontSize: 15.sp, fontWeight: FontWeight.w400,
        color: c.textPrimary, height: 1.5);

  static TextStyle bodyMedium(AppColorScheme c) => GoogleFonts.inter(
        fontSize: 13.sp, fontWeight: FontWeight.w400,
        color: c.textPrimary, height: 1.4);

  static TextStyle bodySmall(AppColorScheme c) => GoogleFonts.inter(
        fontSize: 11.sp, fontWeight: FontWeight.w400,
        color: c.textSecondary, height: 1.4);

  static TextStyle labelLarge(AppColorScheme c) => GoogleFonts.inter(
        fontSize: 12.sp, fontWeight: FontWeight.w600,
        color: c.textSecondary, letterSpacing: 0.8);

  static TextStyle labelSmall(AppColorScheme c) => GoogleFonts.inter(
        fontSize: 10.sp, fontWeight: FontWeight.w500,
        color: c.textMuted, letterSpacing: 0.5);

  static TextStyle chip(AppColorScheme c) => GoogleFonts.inter(
        fontSize: 10.sp, fontWeight: FontWeight.w500,
        color: c.primary, letterSpacing: 0.3);

  // ─── Convenience getters using current active theme ─────────────────────
  // Used by widgets that already read AppColors.current
  static TextStyle get displayMediumCurrent =>
      displayMedium(AppColors.current);
  static TextStyle get headingMediumCurrent =>
      headingMedium(AppColors.current);
  static TextStyle get headingSmallCurrent =>
      headingSmall(AppColors.current);
  static TextStyle get bodyLargeCurrent => bodyLarge(AppColors.current);
  static TextStyle get bodyMediumCurrent => bodyMedium(AppColors.current);
  static TextStyle get bodySmallCurrent => bodySmall(AppColors.current);
  static TextStyle get labelLargeCurrent => labelLarge(AppColors.current);
  static TextStyle get labelSmallCurrent => labelSmall(AppColors.current);
  static TextStyle get chipCurrent => chip(AppColors.current);
}

  static TextStyle get headingLargeCurrent =>
      headingLarge(AppColors.current);
  static TextStyle get bodyLargeCurrent => bodyLarge(AppColors.current);
