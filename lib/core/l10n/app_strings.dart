/// All user-facing strings in one place.
///
/// i18n STRATEGY:
/// - Phase 1 (now): static constants here — zero hardcoded strings in widgets.
/// - Phase 2: swap to generated `AppLocalizations.of(context).xxx` by:
///     1. Add flutter_localizations + intl to pubspec
///     2. Create lib/l10n/app_en.arb (copy keys from here)
///     3. Replace `AppStrings.xxx` with `context.l10n.xxx` via extension
///   No widget changes needed — only this file and app.dart update.
abstract final class AppStrings {
  // ─── App ──────────────────────────────────────────────────────────────────
  static const String appTitle        = 'Star Wars Planets';
  static const String appSubtitle     = 'A galaxy far, far away...';

  // ─── Planets list ─────────────────────────────────────────────────────────
  static const String planetsTitle    = 'PLANETS';
  static const String planetsSubtitle = 'Explore the galaxy';
  static const String refresh         = 'Refresh';
  static const String loadingPlanets  = 'Scanning the galaxy...';

  // ─── Planet detail ────────────────────────────────────────────────────────
  static const String sectionOrbital      = 'ORBITAL DATA';
  static const String sectionEnvironment  = 'ENVIRONMENT';
  static const String sectionFilms        = 'APPEARS IN';
  static const String sectionResidents    = 'GALACTIC CITIZENS';

  static const String fieldDiameter       = 'Diameter';
  static const String fieldRotation       = 'Rotation';
  static const String fieldOrbital        = 'Orbital period';
  static const String fieldGravity        = 'Gravity';
  static const String fieldClimate        = 'Climate';
  static const String fieldTerrain        = 'Terrain';
  static const String fieldSurfaceWater   = 'Surface water';
  static const String fieldPopulation     = 'Population';

  static const String unitKm              = 'km';
  static const String unitHours           = 'hrs';
  static const String unitDays            = 'days';
  static const String unitPercent         = '%';

  // ─── Empty / error states ─────────────────────────────────────────────────
  static const String emptyPlanets        = 'No planets found';
  static const String emptyPlanetsMsg     = 'The galaxy seems empty right now.';
  static const String emptyResidents      = 'No known characters';
  static const String emptyFilms          = 'No film appearances';

  static const String errorTitle          = 'Something went wrong';
  static const String errorTimeout        = 'Request timed out. Check your connection.';
  static const String errorNoConnection   = 'No internet connection.';
  static const String errorNotFound       = 'Resource not found in the galaxy.';
  static const String errorUnknown        = 'An unexpected disturbance in the Force.';
  static const String retryButton         = 'Try again';

  // ─── Unknown value placeholder ────────────────────────────────────────────
  static const String unknown             = '—';

  /// Formats a value for display — replaces SWAPI "unknown"/"n/a" with [unknown].
  static String display(String value) =>
      (value.isEmpty || value == 'unknown' || value == 'n/a') ? unknown : value;
}
