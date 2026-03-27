import 'package:dio/dio.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/data/mapper/planet_mapper.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';

/// Repository implementation lives in the DATA layer (not domain).
///
/// Single Responsibility: orchestrates datasource + mapper.
/// No HTTP details — datasource's job.
/// No business rules — use case's job.
class PlanetsRepository implements IPlanetsRepository {
  const PlanetsRepository(this._datasource);

  final IPlanetsDatasource _datasource;

  @override
  Future<MyResult<List<Planet>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) async {
    final pageResult = await _datasource.getPlanets(
      page: page,
      cancelToken: cancelToken,
    );

    if (pageResult is IsError<PlanetsPageDto>) return IsError(pageResult.error);

    final dto = (pageResult as IsSuccess).model!;
    return _resolveFilmsForList(dto.results, cancelToken);
  }

  @override
  Future<MyResult<Planet>> getPlanetDetail({
    required Planet planet,
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
