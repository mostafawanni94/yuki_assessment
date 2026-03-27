import 'package:dio/dio.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/data/mapper/planet_mapper.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';
import 'package:swapi_planets/feature/planets/data/model/planets_page_dto.dart';

/// Repository implementation — data layer only.
/// Single Responsibility: datasource orchestration + DTO→Entity mapping.
class PlanetsRepository implements IPlanetsRepository {
  const PlanetsRepository(this._datasource);

  final IPlanetsDatasource _datasource;

  // ─── List ────────────────────────────────────────────────────────────────

  @override
  Future<MyResult<List<Planet>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) async {
    final pageResult = await _datasource.getPlanets(
      page: page,
      cancelToken: cancelToken,
    );

    if (pageResult is IsError<PlanetsPageDto>) {
      return IsError(pageResult.error);
    }

    final dto = (pageResult as IsSuccess<PlanetsPageDto>).model!;
    return _resolveFilmsForList(dto.results, cancelToken);
  }

  // ─── Detail ───────────────────────────────────────────────────────────────

  @override
  Future<MyResult<Planet>> getPlanetDetail({
    required Planet planet,
    required CancelToken cancelToken,
  }) async {
    try {
      // Films on the planet may already be resolved titles (from list screen).
      // Only re-fetch if they look like SWAPI URLs (start with "https://").
      // This prevents sending "Attack of the Clones" as a URL → 404.
      final filmUrls      = planet.films.where(_isUrl).toList();
      final resolvedFilms = planet.films.where((f) => !_isUrl(f)).toList();

      final results = await Future.wait([
        // Fetch any remaining unresolved film URLs
        _resolveUrls(
          urls: filmUrls,
          resolver: (url) => _datasource.getFilmTitle(
              filmUrl: url, cancelToken: cancelToken),
        ),
        // Always resolve residents (they come as raw URLs from list screen)
        _resolveUrls(
          urls: planet.residents,
          resolver: (url) => _datasource.getResidentName(
              residentUrl: url, cancelToken: cancelToken),
        ),
      ]);

      return IsSuccess(
        planet.copyWith(
          // Merge already-resolved titles with any newly fetched ones
          films: [...resolvedFilms, ...results[0]],
          residents: results[1],
        ),
      );
    } catch (_) {
      return const IsError(UnknownException());
    }
  }

  // ─── Private helpers ─────────────────────────────────────────────────────

  Future<MyResult<List<Planet>>> _resolveFilmsForList(
    List<dynamic> dtos,
    CancelToken cancelToken,
  ) async {
    try {
      final uniqueUrls = <String>{
        for (final dto in dtos)
          for (final url in (dto.filmUrls as List<String>)) url,
      };

      final titleResults = await Future.wait(
        uniqueUrls.map((url) =>
            _datasource.getFilmTitle(filmUrl: url, cancelToken: cancelToken)),
      );

      final titleMap = Map.fromIterables(
        uniqueUrls,
        titleResults.map(
            (r) => r is IsSuccess<String> ? (r.model ?? '') : ''),
      );

      return IsSuccess(
        dtos.map((dto) {
          final films = (dto.filmUrls as List<String>)
              .map((url) => titleMap[url] ?? '')
              .where((t) => t.isNotEmpty)
              .toList();
          return PlanetMapper.toEntity(dto, films: films);
        }).toList(),
      );
    } catch (_) {
      return const IsError(UnknownException());
    }
  }

  /// Resolves a list of SWAPI URLs to strings concurrently.
  /// Failed fetches are filtered — one bad URL never blocks the screen.
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

  /// Returns true if [s] is a raw SWAPI URL (not yet resolved to a title).
  bool _isUrl(String s) => s.startsWith('https://');
}
