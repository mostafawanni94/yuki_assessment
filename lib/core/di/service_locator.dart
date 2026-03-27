import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapi_planets/core/net/api_service.dart';
import 'package:swapi_planets/core/net/dio_client.dart';
import 'package:swapi_planets/core/net/dio_config.dart';
import 'package:swapi_planets/core/storage/i_local_storage.dart';
import 'package:swapi_planets/core/storage/shared_preferences_storage.dart';
import 'package:swapi_planets/core/theme/theme_cubit.dart';
import 'package:swapi_planets/feature/planets/di/planets_injection.dart';

/// Root DI container.
/// Core infrastructure only — features register via their own modules.
abstract final class InjectionContainer {
  static final GetIt sl = GetIt.instance;

  static Future<void> init() async {
    await _initExternal();
    _initCore();
    _initFeatures();
  }

  // ─── External (async setup) ───────────────────────────────────────────────

  static Future<void> _initExternal() async {
    // SharedPreferences must be awaited before registering
    final prefs = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(prefs);
  }

  // ─── Core ────────────────────────────────────────────────────────────────

  static void _initCore() {
    // Storage — register interface, bind to implementation
    // To swap to Hive: replace SharedPreferencesStorage here only
    sl.registerSingleton<ILocalStorage>(
      SharedPreferencesStorage(sl<SharedPreferences>()),
    );

    // Network
    sl.registerSingleton<DioClient>(DioClient(DioConfig.createBaseOptions()));
    sl.registerSingleton<ApiClient>(ApiClient(sl<DioClient>().dio));

    // Theme
    sl.registerSingleton<ThemeCubit>(ThemeCubit(sl<ILocalStorage>()));
  }

  // ─── Features ────────────────────────────────────────────────────────────

  static void _initFeatures() {
    PlanetsInjection.register(sl);
    // BookingsInjection.register(sl);  ← future feature
    // ProfileInjection.register(sl);   ← future feature
  }
}
