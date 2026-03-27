import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/base_bloc/base_bloc.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planet_detail_params.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planet_detail_usecase.dart';

/// Manages state for the planet detail screen.
/// Extends BaseBloc — single action, retry handled automatically.
/// Depends on [GetPlanetDetailUseCase] — never touches repository.
class PlanetDetailBloc extends BaseBloc<Planet> {
  PlanetDetailBloc({GetPlanetDetailUseCase? useCase})
      : _useCase = useCase ?? GetIt.I<GetPlanetDetailUseCase>();

  final GetPlanetDetailUseCase _useCase;

  Future<void> loadDetail(Planet planet) => performAction(
        () => _useCase.execute(
          GetPlanetDetailParams(
            planet: planet,
            cancelToken: cancelToken,
          ),
        ),
      );
}
