import 'package:get_it/get_it.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/data/datasource/planets_datasource.dart';
import 'package:swapi_planets/feature/planets/data/repository/planets_repository.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planet_detail_usecase.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planets_usecase.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_bloc.dart';

/// Planets feature DI module.
/// Each feature owns its own registrations — keeps service_locator.dart clean.
/// Adding a new feature = create a new *Injection class + call register(sl).
abstract final class PlanetsInjection {
  static void register(GetIt sl) {
    // ── Data layer ──────────────────────────────────────────────────────────
    sl.registerFactory<IPlanetsDatasource>(() => PlanetsDatasource());

    sl.registerFactory<IPlanetsRepository>(
        () => PlanetsRepository(sl<IPlanetsDatasource>()));

    // ── Domain layer (use cases) ────────────────────────────────────────────
    sl.registerFactory<GetPlanetsUseCase>(
        () => GetPlanetsUseCase(sl<IPlanetsRepository>()));

    sl.registerFactory<GetPlanetDetailUseCase>(
        () => GetPlanetDetailUseCase(sl<IPlanetsRepository>()));

    // ── Presentation layer ──────────────────────────────────────────────────
    // lazySingleton: scroll position survives navigation
    sl.registerLazySingleton<PlanetsBloc>(() => PlanetsBloc());
  }
}
