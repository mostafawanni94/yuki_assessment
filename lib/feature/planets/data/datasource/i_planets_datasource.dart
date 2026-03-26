import 'package:dio/dio.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/model/planets_page_model.dart';

/// Contract for the planets remote data source.
/// Single Responsibility: declares what data operations are available.
abstract interface class IPlanetsDatasource {
  /// Fetches one page of planets from SWAPI.
  /// [page] is 1-indexed, matching SWAPI's ?page= parameter.
  Future<MyResult<PlanetsPageModel>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  });

  /// Fetches a single planet by its SWAPI URL (e.g. https://swapi.dev/api/planets/1/).
  Future<MyResult<String>> getFilmTitle({
    required String filmUrl,
    required CancelToken cancelToken,
  });
}
