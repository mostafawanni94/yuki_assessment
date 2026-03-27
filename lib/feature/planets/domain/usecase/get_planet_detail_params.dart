import 'package:swapi_planets/core/usecase/use_case_params.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

/// Parameters for [GetPlanetDetailUseCase].
class GetPlanetDetailParams extends UseCaseParams {
  GetPlanetDetailParams({required this.planet, super.cancelToken});
  final Planet planet;
}
