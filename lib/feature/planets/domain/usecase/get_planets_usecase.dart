import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/core/usecase/use_case.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';
import 'get_planets_params.dart';

/// Fetches one page of planets with film titles resolved.
///
/// Single Responsibility: this one operation only.
/// Depends only on IPlanetsRepository (interface).
class GetPlanetsUseCase implements UseCase<List<Planet>, GetPlanetsParams> {
  const GetPlanetsUseCase(this._repository);

  final IPlanetsRepository _repository;

  @override
  Future<MyResult<List<Planet>>> execute(GetPlanetsParams params) =>
      _repository.getPlanets(
        page: params.page,
        cancelToken: params.cancelToken,
      );
}
