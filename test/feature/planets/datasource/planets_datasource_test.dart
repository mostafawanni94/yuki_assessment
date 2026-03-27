import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/net/api_service.dart';
import 'package:swapi_planets/core/net/http_method.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/planets_datasource.dart';
import 'package:swapi_planets/feature/planets/data/model/planets_page_dto.dart';

import '../../../core/test_helpers.dart';

// ─── Fake ApiClient ───────────────────────────────────────────────────────────

class _FakeApiClient extends Fake implements ApiClient {
  String? lastUrl;
  HttpMethod? lastMethod;
  dynamic lastQueryParams;
  MyResult<dynamic> _response = ok('default');

  void respondWith<T>(MyResult<T> result) => _response = result;

  @override
  Future<MyResult<T>> request<T>({
    required T Function(dynamic) converter,
    required HttpMethod method,
    required String url,
    required CancelToken cancelToken,
    Map<String, String>? headers,
    dynamic queryParameters,
    dynamic body,
  }) async {
    lastUrl = url;
    lastMethod = method;
    lastQueryParams = queryParameters;
    return _response as MyResult<T>;
  }
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late _FakeApiClient fakeClient;
  late PlanetsDatasource datasource;

  setUp(() {
    fakeClient = _FakeApiClient();
    datasource = PlanetsDatasource(client: fakeClient);
  });

  group('getPlanets', () {
    test('calls planets/ with correct page query param', () async {
      fakeClient.respondWith(
          ok(fakePage(dtos: [fakePlanetDto()])));

      await datasource.getPlanets(page: 2, cancelToken: freshToken());

      expect(fakeClient.lastUrl, equals('planets/'));
      expect(fakeClient.lastMethod, equals(HttpMethod.GET));
      expect(fakeClient.lastQueryParams, equals({'page': 2}));
    });

    test('returns IsSuccess with PlanetsPageDto', () async {
      fakeClient.respondWith(
          ok(fakePage(dtos: [fakePlanetDto()])));

      final result = await datasource.getPlanets(
          page: 1, cancelToken: freshToken());

      expect(result, isA<IsSuccess<PlanetsPageDto>>());
    });

    test('propagates error from ApiClient', () async {
      fakeClient.respondWith<PlanetsPageDto>(
          IsError(const TimeoutException()));

      final result = await datasource.getPlanets(
          page: 1, cancelToken: freshToken());

      expect(result, isA<IsError<PlanetsPageDto>>());
    });
  });

  group('getFilmTitle', () {
    test('strips base URL before passing to ApiClient', () async {
      fakeClient.respondWith(ok('A New Hope'));

      await datasource.getFilmTitle(
        filmUrl: 'https://swapi.dev/api/films/1/',
        cancelToken: freshToken(),
      );

      expect(fakeClient.lastUrl, equals('films/1/'));
      expect(fakeClient.lastUrl, isNot(contains('swapi.dev')));
    });

    test('returns resolved title on success', () async {
      fakeClient.respondWith(ok('A New Hope'));

      final result = await datasource.getFilmTitle(
        filmUrl: 'https://swapi.dev/api/films/1/',
        cancelToken: freshToken(),
      );

      expect((result as IsSuccess<String>).model, equals('A New Hope'));
    });

    test('returns error on ApiClient failure', () async {
      fakeClient.respondWith<String>(kTimeout);

      final result = await datasource.getFilmTitle(
        filmUrl: 'https://swapi.dev/api/films/1/',
        cancelToken: freshToken(),
      );

      expect(result, isA<IsError<String>>());
    });
  });

  group('getResidentName', () {
    test('strips base URL and uses people/ path', () async {
      fakeClient.respondWith(ok('Luke Skywalker'));

      await datasource.getResidentName(
        residentUrl: 'https://swapi.dev/api/people/1/',
        cancelToken: freshToken(),
      );

      expect(fakeClient.lastUrl, equals('people/1/'));
    });

    test('returns resolved name on success', () async {
      fakeClient.respondWith(ok('Luke Skywalker'));

      final result = await datasource.getResidentName(
        residentUrl: 'https://swapi.dev/api/people/1/',
        cancelToken: freshToken(),
      );

      expect((result as IsSuccess<String>).model, equals('Luke Skywalker'));
    });
  });
}
