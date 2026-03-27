import 'package:dio/dio.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/model/planets_page_dto.dart';

/// Datasource contract — raw HTTP operations only.
/// Returns DTOs, never entities.
abstract interface class IPlanetsDatasource {
  Future<MyResult<PlanetsPageDto>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  });

  Future<MyResult<String>> getFilmTitle({
    required String filmUrl,
    required CancelToken cancelToken,
  });

  Future<MyResult<String>> getResidentName({
    required String residentUrl,
    required CancelToken cancelToken,
  });
}
