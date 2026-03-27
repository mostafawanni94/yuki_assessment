import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

/// Filters the already-loaded planet list client-side.
///
/// Single Responsibility: search/filter state only — zero HTTP calls.
/// Note: SWAPI has no search API — this filters what's already fetched.
///       On app launch all 60 planets load (6 pages) so search is complete.
class PlanetsSearchCubit extends Cubit<List<Planet>> {
  PlanetsSearchCubit() : super(const []);

  String _query = '';
  List<Planet> _all = [];

  String get query => _query;
  bool get isSearching => _query.isNotEmpty;

  /// Called when new planets are loaded — keeps search in sync.
  void updateSource(List<Planet> all) {
    _all = all;
    _apply();
  }

  /// Called on every keystroke in the search field.
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
    emit(_all.where((p) =>
        p.name.toLowerCase().contains(_query) ||
        p.climate.toLowerCase().contains(_query) ||
        p.terrain.toLowerCase().contains(_query) ||
        p.films.any((f) => f.toLowerCase().contains(_query))).toList());
  }
}
