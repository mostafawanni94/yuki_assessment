import 'package:dio/dio.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'i_planets_repository.dart';

/// Orchestrates fetching and URL→string resolution.
/// Single Responsibility: business logic only — no HTTP details.
/// DRY: [_resolveUrls] handles both films and residents.
class PlanetsRepository implements IPlanetsRepository {
  const PlanetsRepository(this._datasource);

  final IPlanetsDatasource _datasource;

  @override
  Future<MyResult<List<PlanetModel>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) async {
    final pageResult = await _datasource.getPlanets(
      page: page,
      cancelToken: cancelToken,
    );

    if (pageResult is IsError<PlanetsPageModel>) {
      return IsError(pageResult.error);
    }

    final page_ = (pageResult as IsSuccess).model!;
    return _resolveListFilms(page_.results, cancelToken);
  }

  @override
  Future<MyResult<PlanetModel>> getPlanetDetail({
    required PlanetModel planet,
    required CancelToken cancelToken,
  }) async {
    try {
      final results = await Future.wait([
        _resolveUrls(
          urls: planet.films,
          resolver: (url) => _datasource.getFilmTitle(
              filmUrl: url, cancelToken: cancelToken),
        ),
        _resolveUrls(
          urls: planet.residents,
          resolver: (url) => _datasource.getResidentName(
              residentUrl: url, cancelToken: cancelToken),
        ),
      ]);

      return IsSuccess(
        planet.copyWith(films: results[0], residents: results[1]),
      );
    } catch (_) {
      return const IsError(UnknownException());
    }
  }

  // ─── Private helpers ─────────────────────────────────────────────────────

  Future<MyResult<List<PlanetModel>>> _resolveListFilms(
    List<PlanetModel> planets,
    CancelToken cancelToken,
  ) async {
    try {
      final uniqueUrls = {for (final p in planets) ...p.films};

      final titleResults = await Future.wait(
        uniqueUrls.map((url) =>
            _datasource.getFilmTitle(filmUrl: url, cancelToken: cancelToken)),
      );

      final titleMap = Map.fromIterables(
        uniqueUrls,
        titleResults.map((r) =>
            r is IsSuccess<String> ? (r.model ?? '') : ''),
      );

      return IsSuccess(
        planets
            .map((p) => p.copyWith(
                  films: p.films
                      .map((url) => titleMap[url] ?? '')
                      .where((t) => t.isNotEmpty)
                      .toList(),
                ))
            .toList(),
      );
    } catch (_) {
      return const IsError(UnknownException());
    }
  }

  /// Resolves any list of SWAPI URLs to string values concurrently.
  /// Failed fetches are filtered out — one broken URL won't block the screen.
  Future<List<String>> _resolveUrls({
    required List<String> urls,
    required Future<MyResult<String>> Function(String) resolver,
  }) async {
    if (urls.isEmpty) return [];
    final results = await Future.wait(urls.map(resolver));
    return results
        .map((r) => r is IsSuccess<String> ? (r.model ?? '') : '')
        .where((v) => v.isNotEmpty)
        .toList();
  }
}
