import 'package:dio/dio.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'i_planets_repository.dart';

/// Orchestrates data fetching and film URL → title resolution.
///
/// Single Responsibility: business logic only — no HTTP details.
/// DRY: film resolution extracted to [_resolveFilmTitles].
class PlanetsRepository implements IPlanetsRepository {
  const PlanetsRepository(this._datasource);

  final IPlanetsDatasource _datasource;

  @override
  Future<MyResult<List<PlanetModel>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) async {
    // Step 1: fetch the paginated planet list
    final pageResult = await _datasource.getPlanets(
      page: page,
      cancelToken: cancelToken,
    );

    return switch (pageResult) {
      IsError<dynamic>() => MyResult.isError(pageResult.error),
      IsSuccess<dynamic>() => _resolveFilmTitles(
          pageResult.model!.results,
          cancelToken,
        ),
    };
  }

  /// Resolves film URLs to human-readable titles for every planet in [planets].
  ///
  /// Failures are silently replaced with the raw URL so one bad film fetch
  /// never blocks the whole list — UX over strictness.
  Future<MyResult<List<PlanetModel>>> _resolveFilmTitles(
    List<PlanetModel> planets,
    CancelToken cancelToken,
  ) async {
    try {
      // Collect all unique film URLs across all planets
      final uniqueFilmUrls = {
        for (final p in planets) ...p.films,
      };

      // Fetch all titles concurrently
      final titleResults = await Future.wait(
        uniqueFilmUrls.map(
          (url) => _datasource.getFilmTitle(
            filmUrl: url,
            cancelToken: cancelToken,
          ),
        ),
      );

      // Build URL → title map; fall back to URL on error
      final titleMap = Map.fromIterables(
        uniqueFilmUrls,
        titleResults.map((r) => switch (r) {
              IsSuccess<String>(model: final t) => t ?? '',
              IsError<String>() => '',
            }),
      );

      // Replace URL lists with resolved title lists
      final resolved = planets.map(
        (p) => p.copyWith(
          films: p.films
              .map((url) => titleMap[url] ?? url)
              .where((t) => t.isNotEmpty)
              .toList(),
        ),
      ).toList();

      return MyResult.isSuccess(resolved);
    } catch (_) {
      return const MyResult.isError(UnknownException());
    }
  }
}
