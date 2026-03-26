import 'package:dio/dio.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/model/planets_page_model.dart';

/// Contract for the planets remote data source.
/// Single Responsibility: declares what raw data operations are available.
abstract interface class IPlanetsDatasource {
  /// Fetches one page of planets. [page] is 1-indexed.
  Future<MyResult<PlanetsPageModel>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  });

  /// Resolves a film URL to its title string.
  /// e.g. https://swapi.dev/api/films/1/ → "A New Hope"
  Future<MyResult<String>> getFilmTitle({
    required String filmUrl,
    required CancelToken cancelToken,
  });

  /// Resolves a resident (person) URL to their name.
  /// e.g. https://swapi.dev/api/people/1/ → "Luke Skywalker"
  Future<MyResult<String>> getResidentName({
    required String residentUrl,
    required CancelToken cancelToken,
  });
}
