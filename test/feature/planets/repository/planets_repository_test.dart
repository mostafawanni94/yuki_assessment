import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/domain/model/planets_page_model.dart';
import 'package:swapi_planets/feature/planets/domain/repository/planets_repository.dart';

import '../../../core/test_helpers.dart';

// ─── Fake datasource ──────────────────────────────────────────────────────────

class _FakeDatasource extends Fake implements IPlanetsDatasource {
  // Configurable responses
  MyResult<PlanetsPageModel> planetsResult =
      ok(fakePage(planets: [fakePlanet()]));
  MyResult<String> filmResult = ok('A New Hope');
  MyResult<String> residentResult = ok('Luke Skywalker');

  int getPlanetsCalls = 0;
  int getFilmCalls = 0;
  int getResidentCalls = 0;

  @override
  Future<MyResult<PlanetsPageModel>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) async {
    getPlanetsCalls++;
    return planetsResult;
  }

  @override
  Future<MyResult<String>> getFilmTitle({
    required String filmUrl,
    required CancelToken cancelToken,
  }) async {
    getFilmCalls++;
    return filmResult;
  }

  @override
  Future<MyResult<String>> getResidentName({
    required String residentUrl,
    required CancelToken cancelToken,
  }) async {
    getResidentCalls++;
    return residentResult;
  }
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late _FakeDatasource fakeDatasource;
  late PlanetsRepository repository;

  setUp(() {
    fakeDatasource = _FakeDatasource();
    repository = PlanetsRepository(fakeDatasource);
  });

  // ─── getPlanets ───────────────────────────────────────────────────────────

  group('getPlanets', () {
    test('returns planet list on success', () async {
      final result = await repository.getPlanets(
        page: 1,
        cancelToken: freshToken(),
      );

      expect(result, isA<IsSuccess<List<PlanetModel>>>());
    });

    test('resolves film URLs to titles', () async {
      fakeDatasource.planetsResult = ok(fakePage(planets: [
        fakePlanet(films: ['https://swapi.dev/api/films/1/']),
      ]));
      fakeDatasource.filmResult = ok('A New Hope');

      final result = await repository.getPlanets(
        page: 1,
        cancelToken: freshToken(),
      );

      final planets = (result as IsSuccess<List<PlanetModel>>).model!;
      expect(planets.first.films, equals(['A New Hope']));
    });

    test('deduplicates film URLs across planets — calls datasource once per unique URL', () async {
      // Two planets sharing the same film URL
      final sharedFilmUrl = 'https://swapi.dev/api/films/1/';
      fakeDatasource.planetsResult = ok(fakePage(planets: [
        fakePlanet(name: 'Tatooine', films: [sharedFilmUrl]),
        fakePlanet(name: 'Alderaan', films: [sharedFilmUrl]),
      ]));

      await repository.getPlanets(page: 1, cancelToken: freshToken());

      // Should only fetch the film once despite two planets referencing it
      expect(fakeDatasource.getFilmCalls, equals(1));
    });

    test('keeps planet in list even when film fetch fails', () async {
      fakeDatasource.planetsResult = ok(fakePage(planets: [fakePlanet()]));
      fakeDatasource.filmResult =
          const MyResult.isError(TimeoutException());

      final result = await repository.getPlanets(
        page: 1,
        cancelToken: freshToken(),
      );

      // Planet list still returned — degraded gracefully
      expect(result, isA<IsSuccess<List<PlanetModel>>>());
      final planets = (result as IsSuccess<List<PlanetModel>>).model!;
      expect(planets.length, equals(1));
      // Film list is empty (failed fetch filtered out)
      expect(planets.first.films, isEmpty);
    });

    test('returns error when getPlanets datasource call fails', () async {
      fakeDatasource.planetsResult =
          const MyResult.isError(TimeoutException());

      final result = await repository.getPlanets(
        page: 1,
        cancelToken: freshToken(),
      );

      expect(result, isA<IsError<List<PlanetModel>>>());
    });
  });

  // ─── getPlanetDetail ──────────────────────────────────────────────────────

  group('getPlanetDetail', () {
    test('resolves both films and residents concurrently', () async {
      final planet = fakePlanet(
        films: ['https://swapi.dev/api/films/1/'],
        residents: ['https://swapi.dev/api/people/1/'],
      );
      fakeDatasource.filmResult = ok('A New Hope');
      fakeDatasource.residentResult = ok('Luke Skywalker');

      final result = await repository.getPlanetDetail(
        planet: planet,
        cancelToken: freshToken(),
      );

      final detail = (result as IsSuccess<PlanetModel>).model!;
      expect(detail.films, equals(['A New Hope']));
      expect(detail.residents, equals(['Luke Skywalker']));
    });

    test('planet with no residents returns empty residents list', () async {
      final planet = fakePlanet(residents: []);

      final result = await repository.getPlanetDetail(
        planet: planet,
        cancelToken: freshToken(),
      );

      final detail = (result as IsSuccess<PlanetModel>).model!;
      expect(detail.residents, isEmpty);
      // No resident calls made
      expect(fakeDatasource.getResidentCalls, equals(0));
    });

    test('failed resident fetch is filtered — others still returned', () async {
      final planet = fakePlanet(
        residents: [
          'https://swapi.dev/api/people/1/',
          'https://swapi.dev/api/people/2/',
        ],
      );
      // All resident fetches fail
      fakeDatasource.residentResult =
          const MyResult.isError(TimeoutException());

      final result = await repository.getPlanetDetail(
        planet: planet,
        cancelToken: freshToken(),
      );

      // Detail still returned — residents list is just empty
      expect(result, isA<IsSuccess<PlanetModel>>());
      final detail = (result as IsSuccess<PlanetModel>).model!;
      expect(detail.residents, isEmpty);
    });

    test('returns success even when both films and residents fail', () async {
      fakeDatasource.filmResult =
          const MyResult.isError(TimeoutException());
      fakeDatasource.residentResult =
          const MyResult.isError(TimeoutException());

      final result = await repository.getPlanetDetail(
        planet: fakePlanet(),
        cancelToken: freshToken(),
      );

      expect(result, isA<IsSuccess<PlanetModel>>());
    });
  });
}
