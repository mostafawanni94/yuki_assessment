import 'package:dio/dio.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';

/// Repository contract — the BLoC depends on this, NOT on the datasource.
/// Single Responsibility: defines what the feature needs from the data layer.
abstract interface class IPlanetsRepository {
  /// Returns all planets for [page], with [films] resolved to title strings.
  Future<MyResult<List<PlanetModel>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  });
}
