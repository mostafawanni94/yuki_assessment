import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapi_planets/core/storage/i_local_storage.dart';
import 'package:swapi_planets/core/storage/storage_keys.dart';
import 'app_colors.dart';

/// Manages the active theme + persists selection across restarts.
///
/// Single Responsibility: theme state + persistence.
/// Depends on ILocalStorage (interface) — not SharedPreferences directly.
/// Swap storage backend: change DI registration, zero cubit changes.
class ThemeCubit extends Cubit<AppColorScheme> {
  ThemeCubit(this._storage) : super(spaceTheme);

  final ILocalStorage _storage;

  /// Call once on startup — restores the theme the user last selected.
  Future<void> loadSavedTheme() async {
    final index = await _storage.getInt(StorageKeys.themeIndex);
    if (index != null && index >= 0 && index < availableThemes.length) {
      final saved = availableThemes[index];
      AppColors.current = saved;
      emit(saved);
    }
  }

  /// Cycles to the next available theme and persists the choice.
  Future<void> nextTheme() async {
    final idx = availableThemes.indexOf(state);
    final next = availableThemes[(idx + 1) % availableThemes.length];
    await _persist(next);
  }

  /// Switches to a specific theme and persists the choice.
  Future<void> setTheme(AppColorScheme scheme) async {
    await _persist(scheme);
  }

  // ─── Private ─────────────────────────────────────────────────────────────

  Future<void> _persist(AppColorScheme scheme) async {
    AppColors.current = scheme;
    emit(scheme);
    final index = availableThemes.indexOf(scheme);
    await _storage.setInt(StorageKeys.themeIndex, index);
  }
}
