import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/net/api_service.dart';
import 'package:swapi_planets/core/net/dio_client.dart';
import 'package:swapi_planets/core/net/dio_config.dart';
import 'package:swapi_planets/core/theme/theme_cubit.dart';
import 'package:swapi_planets/feature/planets/di/planets_injection.dart';

/// Root DI container.
/// Core infrastructure only — features register via their own modules.
/// Adding a feature: create FeatureInjection.register(sl) and call it here.
abstract final class InjectionContainer {
  static final GetIt sl = GetIt.instance;

  static Future<void> init() async {
    _initCore();
    _initFeatures();
  }

  // ─── Core ────────────────────────────────────────────────────────────────

  static void _initCore() {
    sl.registerSingleton<DioClient>(DioClient(DioConfig.createBaseOptions()));
    sl.registerSingleton<ApiClient>(ApiClient(sl<DioClient>().dio));
    sl.registerSingleton<ThemeCubit>(ThemeCubit());
  }

  // ─── Features ────────────────────────────────────────────────────────────
  // Each line = one feature module. Easy to add / remove features.

  static void _initFeatures() {
    PlanetsInjection.register(sl);
    // BookingsInjection.register(sl);   ← future feature
    // ProfileInjection.register(sl);    ← future feature
  }
}
