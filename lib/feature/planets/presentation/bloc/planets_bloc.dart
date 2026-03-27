import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/errors/not_found_exception.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planets_params.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planets_usecase.dart';

/// Manages the planets list with pagination.
/// Depends on [GetPlanetsUseCase] — never touches repository directly.
class PlanetsBloc extends Cubit<BaseState<List<Planet>>> {
  PlanetsBloc({GetPlanetsUseCase? getPlanetsUseCase})
      : _useCase = getPlanetsUseCase ?? GetIt.I<GetPlanetsUseCase>(),
        super(const Init());

  final GetPlanetsUseCase _useCase;

  int _currentPage = 1;
  bool _hasMore = true;
  CancelToken _cancelToken = CancelToken();
  final List<Planet> _planets = [];

  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  List<Planet> get cachedPlanets => List.unmodifiable(_planets);

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

      final result = await _useCase.execute(
        GetPlanetsParams(page: _currentPage, cancelToken: _cancelToken),
      );

      if (isClosed) return;

      if (result is IsSuccess<List<Planet>>) {
        final incoming = result.model ?? [];
        _planets.addAll(incoming);
        _hasMore = incoming.length == 10;
        if (_hasMore) _currentPage++;
        emit(Success(List.unmodifiable(_planets)));
      } else if (result is IsError<List<Planet>>) {
        // 404 on page 2+ = end of SWAPI data (60 planets total)
        if (result.error is NotFoundException && !isFirstPage) {
          _hasMore = false;
          emit(Success(List.unmodifiable(_planets)));
        } else {
          emit(Failure(result.error, retry));
        }
      }
    } catch (e, stack) {
      debugPrint('[PlanetsBloc] error: $e\n$stack');
      if (!isClosed) emit(Failure(const UnknownException(), retry));
    }
  }

  @override
  Future<void> close() {
    _cancelToken.cancel();
    return super.close();
  }
}
