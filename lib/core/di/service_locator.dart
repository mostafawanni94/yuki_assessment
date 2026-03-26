import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/net/api_service.dart';
import 'package:swapi_planets/core/net/dio_client.dart';
import 'package:swapi_planets/core/net/dio_config.dart';

/// Dependency injection root.
/// Add feature registrations in separate extension methods as features grow.
abstract final class InjectionContainer {
  static final GetIt sl = GetIt.instance;

  static Future<void> init() async {
    _initCore();
    // Feature registrations added per branch, e.g.:
    // PlanetsInjection.register(sl);
  }

  static void _initCore() {
    sl.registerSingleton<DioClient>(DioClient(DioConfig.createBaseOptions()));
    sl.registerSingleton<ApiClient>(ApiClient(sl<DioClient>().dio));
  }
}
