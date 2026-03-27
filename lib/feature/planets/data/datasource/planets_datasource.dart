import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/net/api_service.dart';
import 'package:swapi_planets/core/net/api_url.dart';
import 'package:swapi_planets/core/net/http_method.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/model/planets_page_dto.dart';
import 'i_planets_datasource.dart';

/// Concrete SWAPI datasource.
/// Single Responsibility: raw HTTP calls → DTOs.
/// DRY: [_resolveField] handles both film titles and resident names.
class PlanetsDatasource implements IPlanetsDatasource {
  PlanetsDatasource({ApiClient? client})
      : _client = client ?? GetIt.I<ApiClient>();

  final ApiClient _client;

  @override
  Future<MyResult<PlanetsPageDto>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) =>
      _client.request<PlanetsPageDto>(
        method: HttpMethod.GET,
        url: ApiUrl.planets,
        cancelToken: cancelToken,
        queryParameters: {'page': page},
        converter: (json) =>
            PlanetsPageDto.fromJson(json as Map<String, dynamic>),
      );

  @override
  Future<MyResult<String>> getFilmTitle({
    required String filmUrl,
    required CancelToken cancelToken,
  }) =>
      _resolveField(url: filmUrl, field: 'title', cancelToken: cancelToken);

  @override
  Future<MyResult<String>> getResidentName({
    required String residentUrl,
    required CancelToken cancelToken,
  }) =>
      _resolveField(url: residentUrl, field: 'name', cancelToken: cancelToken);

  /// DRY: both films and residents are "GET url → pick one field".
  Future<MyResult<String>> _resolveField({
    required String url,
    required String field,
    required CancelToken cancelToken,
  }) =>
      _client.request<String>(
        method: HttpMethod.GET,
        url: _stripBase(url),
        cancelToken: cancelToken,
        converter: (json) => (json as Map<String, dynamic>)[field] as String,
      );

  String _stripBase(String url) =>
      url.replaceFirst('https://swapi.dev/api/', '');
}
