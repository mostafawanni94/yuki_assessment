import 'package:dio/dio.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'i_planets_repository.dart';

/// Orchestrates data fetching and URL→string resolution.
/// Single Responsibility: business logic only — no HTTP details.
/// DRY: [_resolveUrls] handles both films and residents with one method.
class PlanetsRepository implements IPlanetsRepository {
  const PlanetsRepository(this._datasource);

  final IPlanetsDatasource _datasource;

  // ─── List ────────────────────────────────────────────────────────────────

  @override
  Future<MyResult<List<PlanetModel>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) async {
    final pageResult = await _datasource.getPlanets(
      page: page,
      cancelToken: cancelToken,
    );

    return switch (pageResult) {
      IsError<dynamic>() => MyResult.isError(pageResult.error),
      IsSuccess<dynamic>() => _resolveListFilms(
          pageResult.model!.results,
          cancelToken,
        ),
    };
  }

  // ─── Detail ───────────────────────────────────────────────────────────────

  @override
  Future<MyResult<PlanetModel>> getPlanetDetail({
    required PlanetModel planet,
    required CancelToken cancelToken,
  }) async {
    try {
      // Resolve films + residents concurrently for speed
      final results = await Future.wait([
        _resolveUrls(
          urls: planet.films,
          resolver: (url) => _datasource.getFilmTitle(
            filmUrl: url,
            cancelToken: cancelToken,
          ),
        ),
        _resolveUrls(
          urls: planet.residents,
          resolver: (url) => _datasource.getResidentName(
            residentUrl: url,
            cancelToken: cancelToken,
          ),
        ),
      ]);

      return MyResult.isSuccess(
        planet.copyWith(
          films: results[0],
          residents: results[1],
        ),
      );
    } catch (_) {
      return const MyResult.isError(UnknownException());
    }
  }

  // ─── Private helpers ─────────────────────────────────────────────────────

  /// Resolves film URLs to titles for a list of planets (used by list screen).
  Future<MyResult<List<PlanetModel>>> _resolveListFilms(
    List<PlanetModel> planets,
    CancelToken cancelToken,
  ) async {
    try {
      final uniqueFilmUrls = {for (final p in planets) ...p.films};

      final titleResults = await Future.wait(
        uniqueFilmUrls.map(
          (url) => _datasource.getFilmTitle(
            filmUrl: url,
            cancelToken: cancelToken,
          ),
        ),
      );

      final titleMap = Map.fromIterables(
        uniqueFilmUrls,
        titleResults.map((r) => switch (r) {
              IsSuccess<String>(model: final t) => t ?? '',
              IsError<String>() => '',
            }),
      );

      return MyResult.isSuccess(
        planets
            .map((p) => p.copyWith(
                  films: p.films
                      .map((url) => titleMap[url] ?? url)
                      .where((t) => t.isNotEmpty)
                      .toList(),
                ))
            .toList(),
      );
    } catch (_) {
      return const MyResult.isError(UnknownException());
    }
  }

  /// DRY: resolves any list of SWAPI URLs to string values.
  /// Failed fetches return empty string and are filtered out — one bad
  /// URL never blocks the whole detail screen.
  Future<List<String>> _resolveUrls({
    required List<String> urls,
    required Future<MyResult<String>> Function(String url) resolver,
  }) async {
    if (urls.isEmpty) return [];

    final results = await Future.wait(urls.map(resolver));
    return results
        .map((r) => switch (r) {
              IsSuccess<String>(model: final v) => v ?? '',
              IsError<String>() => '',
            })
        .where((v) => v.isNotEmpty)
        .toList();
  }
}
