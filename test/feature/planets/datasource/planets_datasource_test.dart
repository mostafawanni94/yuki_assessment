import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/net/api_service.dart';
import 'package:swapi_planets/core/net/http_method.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/planets_datasource.dart';
import 'package:swapi_planets/feature/planets/domain/model/planets_page_model.dart';

import '../../../core/test_helpers.dart';

// ─── Fakes ───────────────────────────────────────────────────────────────────

/// Fake ApiClient — records the last call params for assertion.
class _FakeApiClient extends Fake implements ApiClient {
  String? lastUrl;
  HttpMethod? lastMethod;
  dynamic lastQueryParams;

  MyResult<dynamic> _response = ok('default');

  void respondWith<T>(MyResult<T> result) => _response = result;

  @override
  Future<MyResult<T>> request<T>({
    required T Function(dynamic p1) converter,
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

  // ─── getPlanets ───────────────────────────────────────────────────────────

  group('getPlanets', () {
    test('calls planets/ with correct page query param', () async {
      fakeClient.respondWith(ok(fakePage(planets: [fakePlanet()])));

      await datasource.getPlanets(page: 2, cancelToken: freshToken());

      expect(fakeClient.lastUrl, equals('planets/'));
      expect(fakeClient.lastMethod, equals(HttpMethod.GET));
      expect(fakeClient.lastQueryParams, equals({'page': 2}));
    });

    test('returns success with page model', () async {
      final page = fakePage(planets: [fakePlanet()]);
      fakeClient.respondWith<PlanetsPageModel>(ok(page));

      final result = await datasource.getPlanets(
        page: 1,
        cancelToken: freshToken(),
      );

      expect(result, isA<IsSuccess<PlanetsPageModel>>());
    });

    test('propagates error from ApiClient', () async {
      fakeClient.respondWith<PlanetsPageModel>(
          const MyResult.isError(TimeoutException()));

      final result = await datasource.getPlanets(
        page: 1,
        cancelToken: freshToken(),
      );

      expect(result, isA<IsError<PlanetsPageModel>>());
    });
  });

  // ─── getFilmTitle ─────────────────────────────────────────────────────────

  group('getFilmTitle', () {
    test('strips https://swapi.dev/api/ prefix before calling ApiClient', () async {
      fakeClient.respondWith(ok('A New Hope'));

      await datasource.getFilmTitle(
        filmUrl: 'https://swapi.dev/api/films/1/',
        cancelToken: freshToken(),
      );

      // Must NOT include the base URL — Dio would double-prefix it
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

  // ─── getResidentName ──────────────────────────────────────────────────────

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
