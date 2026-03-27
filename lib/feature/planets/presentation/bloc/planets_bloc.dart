import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/errors/not_found_exception.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';

export 'planets_event.dart';

class PlanetsBloc extends Cubit<BaseState<List<PlanetModel>>> {
  PlanetsBloc({IPlanetsRepository? repository})
      : _repository = repository ?? GetIt.I<IPlanetsRepository>(),
        super(const Init());

  final IPlanetsRepository _repository;

  int _currentPage = 1;
  bool _hasMore = true;
  CancelToken _cancelToken = CancelToken();
  final List<PlanetModel> _planets = [];

  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  List<PlanetModel> get cachedPlanets => List.unmodifiable(_planets);

  Future<void> loadPlanets() async {
    _reset();
    await _fetchPage();
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    await _fetchPage();
  }

  Future<void> retry() => _fetchPage();

  void _reset() {
    _cancelToken.cancel();
    _cancelToken = CancelToken();
    _currentPage = 1;
    _hasMore = true;
    _planets.clear();
  }

  Future<void> _fetchPage() async {
    if (isClosed) return;
    final isFirstPage = _currentPage == 1;

    try {
      emit(const Loading());

      final result = await _repository.getPlanets(
        page: _currentPage,
        cancelToken: _cancelToken,
      );

      if (isClosed) return;

      if (result is IsSuccess<List<PlanetModel>>) {
        final incoming = result.model ?? [];
        _planets.addAll(incoming);
        // SWAPI returns 10/page; fewer = last page
        _hasMore = incoming.length == 10;
        if (_hasMore) _currentPage++;
        emit(Success(List.unmodifiable(_planets)));
      } else if (result is IsError<List<PlanetModel>>) {
        // 404 on a subsequent page = we've reached the end of SWAPI data
        // Show the planets we already have instead of an error screen
        if (result.error is NotFoundException && !isFirstPage) {
          _hasMore = false;
          debugPrint('[PlanetsBloc] Page $_currentPage not found — end of data');
          emit(Success(List.unmodifiable(_planets)));
        } else {
          emit(Failure(result.error, retry));
        }
      }
    } catch (e, stack) {
      debugPrint('[PlanetsBloc] _fetchPage error: $e\n$stack');
      if (!isClosed) emit(Failure(const UnknownException(), retry));
    }
  }

  @override
  Future<void> close() {
    _cancelToken.cancel();
    return super.close();
  }
}
