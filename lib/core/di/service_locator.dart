import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/net/api_service.dart';
import 'package:swapi_planets/core/net/dio_client.dart';
import 'package:swapi_planets/core/net/dio_config.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/data/datasource/planets_datasource.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';
import 'package:swapi_planets/feature/planets/domain/repository/planets_repository.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_bloc.dart';

/// Dependency injection root.
/// Each feature registers in its own private method — DRY + easy to review.
abstract final class InjectionContainer {
  static final GetIt sl = GetIt.instance;

  static Future<void> init() async {
    _initCore();
    _initPlanetsFeature();
  }

  // ─── Core ────────────────────────────────────────────────────────────────

  static void _initCore() {
    sl.registerSingleton<DioClient>(DioClient(DioConfig.createBaseOptions()));
    sl.registerSingleton<ApiClient>(ApiClient(sl<DioClient>().dio));
  }

  // ─── Planets feature ─────────────────────────────────────────────────────

  static void _initPlanetsFeature() {
    // Data layer
    sl.registerFactory<IPlanetsDatasource>(() => PlanetsDatasource());

    // Domain layer
    sl.registerFactory<IPlanetsRepository>(
      () => PlanetsRepository(sl<IPlanetsDatasource>()),
    );

    // Presentation layer — lazySingleton keeps scroll position alive
    // across navigations; call sl.resetLazySingleton<PlanetsBloc>() to reset.
    sl.registerLazySingleton<PlanetsBloc>(() => PlanetsBloc());
  }
}
