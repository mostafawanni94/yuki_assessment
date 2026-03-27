import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

/// Filters the already-loaded planet list client-side.
/// Single Responsibility: search state only — no HTTP calls.
/// DRY: filtering logic in one place, not duplicated in UI.
class PlanetsSearchCubit extends Cubit<List<Planet>> {
  PlanetsSearchCubit() : super([]);

  String _query = '';
  List<Planet> _all = [];

  String get query => _query;

  /// Called when the full planet list updates (new page loaded).
  void updateSource(List<Planet> all) {
    _all = all;
    _apply();
  }

  /// Called when user types in the search bar.
  void search(String query) {
    _query = query.trim().toLowerCase();
    _apply();
  }

  void clear() {
    _query = '';
    _apply();
  }

  void _apply() {
    if (_query.isEmpty) {
      emit(List.unmodifiable(_all));
      return;
    }
    emit(
      _all
          .where((p) =>
              p.name.toLowerCase().contains(_query) ||
              p.climate.toLowerCase().contains(_query) ||
              p.terrain.toLowerCase().contains(_query) ||
              p.films.any((f) => f.toLowerCase().contains(_query)))
          .toList(),
    );
  }
}
