/// All storage keys in one place.
///
/// Never use raw strings in feature code — always reference this class.
/// Adding a new persisted value: add a key here, nowhere else.
abstract final class StorageKeys {
  // ─── Theme ────────────────────────────────────────────────────────────────
  /// Stores the index of the selected theme in [availableThemes].
  static const String themeIndex = 'theme_index';

  // ─── Future keys go here ──────────────────────────────────────────────────
  // static const String locale        = 'locale';
  // static const String onboardingDone = 'onboarding_done';
  // static const String userToken      = 'user_token';
}
