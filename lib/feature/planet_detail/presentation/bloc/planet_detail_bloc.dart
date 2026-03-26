import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/base_bloc/base_bloc.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';

/// Manages state for the planet detail screen.
///
/// Extends [BaseBloc] — single action (load detail), BaseBloc handles
/// loading/error/retry wiring automatically.
class PlanetDetailBloc extends BaseBloc<PlanetModel> {
  PlanetDetailBloc({IPlanetsRepository? repository})
      : _repository = repository ?? GetIt.I<IPlanetsRepository>();

  final IPlanetsRepository _repository;

  /// Loads the full detail for [planet], resolving all film + resident URLs.
  /// The [planet] passed from the list screen already has film *titles* —
  /// re-fetching gives us resident names too.
  Future<void> loadDetail(PlanetModel planet) => performAction(
        () => _repository.getPlanetDetail(
          planet: planet,
          cancelToken: cancelToken,
        ),
      );
}
