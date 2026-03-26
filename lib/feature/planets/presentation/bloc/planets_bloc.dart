import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';
import 'planets_event.dart';

export 'planets_event.dart';

/// Manages the state for the planets list screen.
///
/// Extends [Cubit] directly (not [BaseBloc]) because pagination requires
/// accumulating pages — BaseBloc replaces state on each call.
class PlanetsBloc extends Cubit<BaseState<List<PlanetModel>>> {
  PlanetsBloc({IPlanetsRepository? repository})
      : _repository = repository ?? GetIt.I<IPlanetsRepository>(),
        super(const BaseState.init());

  final IPlanetsRepository _repository;

  // ─── Pagination state ────────────────────────────────────────────────────
  int _currentPage = 1;
  bool _hasMore = true;
  CancelToken _cancelToken = CancelToken();
  final List<PlanetModel> _planets = [];

  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  // ─── Public events ────────────────────────────────────────────────────────

  /// Loads the first page — clears any existing data.
  Future<void> loadPlanets() async {
    _reset();
    await _fetchPage();
  }

  /// Loads the next page — appends to existing list.
  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    await _fetchPage();
  }

  /// Retries the last failed page.
  Future<void> retry() => _fetchPage();

  // ─── Private helpers ──────────────────────────────────────────────────────

  void _reset() {
    _cancelToken.cancel();
    _cancelToken = CancelToken();
    _currentPage = 1;
    _hasMore = true;
    _planets.clear();
  }

  Future<void> _fetchPage() async {
    if (isClosed) return;
    emit(const BaseState.loading());

    final result = await _repository.getPlanets(
      page: _currentPage,
      cancelToken: _cancelToken,
    );

    if (isClosed) return;

    switch (result) {
      case IsSuccess<List<PlanetModel>>():
        final incoming = result.model ?? [];
        _planets.addAll(incoming);
        // SWAPI returns 10 per page; fewer = last page
        _hasMore = incoming.length == 10;
        if (_hasMore) _currentPage++;
        emit(BaseState.success(List.unmodifiable(_planets)));

      case IsError<List<PlanetModel>>():
        emit(BaseState.failure(result.error, retry));
    }
  }

  @override
  Future<void> close() {
    _cancelToken.cancel();
    return super.close();
  }
}
