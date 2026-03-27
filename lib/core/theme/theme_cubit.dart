import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_colors.dart';

/// Manages the active theme.
/// Single Responsibility: holds current theme index + emits on change.
/// Extensible: add more themes to [availableThemes] — no cubit change needed.
class ThemeCubit extends Cubit<AppColorScheme> {
  ThemeCubit() : super(spaceTheme);

  /// Cycle to the next available theme.
  void nextTheme() {
    final idx = availableThemes.indexOf(state);
    final next = availableThemes[(idx + 1) % availableThemes.length];
    AppColors.current = next;
    emit(next);
  }

  /// Switch to a specific theme by name.
  void setTheme(AppColorScheme scheme) {
    AppColors.current = scheme;
    emit(scheme);
  }
}
