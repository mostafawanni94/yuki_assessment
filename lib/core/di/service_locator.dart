import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/net/api_service.dart';
import 'package:swapi_planets/core/net/dio_client.dart';
import 'package:swapi_planets/core/net/dio_config.dart';
import 'package:swapi_planets/core/theme/theme_cubit.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/data/datasource/planets_datasource.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';
import 'package:swapi_planets/feature/planets/domain/repository/planets_repository.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_bloc.dart';

abstract final class InjectionContainer {
  static final GetIt sl = GetIt.instance;

  static Future<void> init() async {
    _initCore();
    _initPlanetsFeature();
  }

  static void _initCore() {
    sl.registerSingleton<DioClient>(DioClient(DioConfig.createBaseOptions()));
    sl.registerSingleton<ApiClient>(ApiClient(sl<DioClient>().dio));
    sl.registerSingleton<ThemeCubit>(ThemeCubit());
  }

  static void _initPlanetsFeature() {
    sl.registerFactory<IPlanetsDatasource>(() => PlanetsDatasource());
    sl.registerFactory<IPlanetsRepository>(
        () => PlanetsRepository(sl<IPlanetsDatasource>()));
    sl.registerLazySingleton<PlanetsBloc>(() => PlanetsBloc());
  }
}
