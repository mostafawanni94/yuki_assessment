import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/core/usecase/use_case.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';
import 'get_planet_detail_params.dart';

/// Fetches full planet detail with films + resident names resolved.
///
/// Single Responsibility: detail resolution only.
class GetPlanetDetailUseCase
    implements UseCase<Planet, GetPlanetDetailParams> {
  const GetPlanetDetailUseCase(this._repository);

  final IPlanetsRepository _repository;

  @override
  Future<MyResult<Planet>> execute(GetPlanetDetailParams params) =>
      _repository.getPlanetDetail(
        planet: params.planet,
        cancelToken: params.cancelToken,
      );
}
