import 'package:dio/dio.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

/// Repository contract — domain layer boundary.
/// Returns entities, never DTOs.
/// BLoC and use cases depend only on this interface.
abstract interface class IPlanetsRepository {
  /// Returns page of planets with film titles resolved.
  Future<MyResult<List<Planet>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  });

  /// Returns a single planet with films + resident names fully resolved.
  Future<MyResult<Planet>> getPlanetDetail({
    required Planet planet,
    required CancelToken cancelToken,
  });
}
