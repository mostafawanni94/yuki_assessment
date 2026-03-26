import 'package:dio/dio.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';

/// Repository contract.
/// BLoC depends on this abstraction — never on datasource directly.
abstract interface class IPlanetsRepository {
  /// Returns paginated planet list with film URLs resolved to titles.
  Future<MyResult<List<PlanetModel>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  });

  /// Returns a single planet with both film titles AND resident names resolved.
  /// Used by the detail screen.
  Future<MyResult<PlanetModel>> getPlanetDetail({
    required PlanetModel planet,
    required CancelToken cancelToken,
  });
}
