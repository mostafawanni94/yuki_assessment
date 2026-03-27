import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/datasource/i_planets_datasource.dart';
import 'package:swapi_planets/feature/planets/data/model/planets_page_dto.dart';
import 'package:swapi_planets/feature/planets/data/repository/planets_repository.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

import '../../../core/test_helpers.dart';

class _FakeDatasource extends Fake implements IPlanetsDatasource {
  MyResult<PlanetsPageDto> planetsResult =
      ok(fakePage(dtos: [fakePlanetDto()]));
  MyResult<String> filmResult     = ok('A New Hope');
  MyResult<String> residentResult = ok('Luke Skywalker');

  int getPlanetsCalls   = 0;
  int getFilmCalls      = 0;
  int getResidentCalls  = 0;

  @override
  Future<MyResult<PlanetsPageDto>> getPlanets({
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

void main() {
  late _FakeDatasource fakeDatasource;
  late PlanetsRepository repository;

  setUp(() {
    fakeDatasource = _FakeDatasource();
    repository = PlanetsRepository(fakeDatasource);
  });

  group('getPlanets', () {
    test('returns List<Planet> on success', () async {
      final result = await repository.getPlanets(
          page: 1, cancelToken: freshToken());

      expect(result, isA<IsSuccess<List<Planet>>>());
    });

    test('maps DTO to Planet entity via PlanetMapper', () async {
      fakeDatasource.planetsResult =
          ok(fakePage(dtos: [fakePlanetDto(name: 'Tatooine')]));
      fakeDatasource.filmResult = ok('A New Hope');

      final result = await repository.getPlanets(
          page: 1, cancelToken: freshToken());

      final planets = (result as IsSuccess<List<Planet>>).model!;
      expect(planets.first.name, equals('Tatooine'));
      // Film URL should be replaced with resolved title
      expect(planets.first.films, equals(['A New Hope']));
    });

    test('deduplicates film URLs across planets — one fetch per unique URL', () async {
      final sharedFilmUrl = 'https://swapi.dev/api/films/1/';
      fakeDatasource.planetsResult = ok(fakePage(dtos: [
        fakePlanetDto(name: 'Tatooine', filmUrls: [sharedFilmUrl]),
        fakePlanetDto(name: 'Alderaan',
            url: 'https://swapi.dev/api/planets/2/',
            filmUrls: [sharedFilmUrl]),
      ]));

      await repository.getPlanets(page: 1, cancelToken: freshToken());

      expect(fakeDatasource.getFilmCalls, equals(1));
    });

    test('keeps planet when film fetch fails (graceful degradation)', () async {
      fakeDatasource.filmResult =
          IsError(const TimeoutException());

      final result = await repository.getPlanets(
          page: 1, cancelToken: freshToken());

      expect(result, isA<IsSuccess<List<Planet>>>());
      final planets = (result as IsSuccess<List<Planet>>).model!;
      expect(planets.length, equals(1));
      expect(planets.first.films, isEmpty);
    });

    test('returns IsError when datasource fails', () async {
      fakeDatasource.planetsResult =
          IsError(const TimeoutException());

      final result = await repository.getPlanets(
          page: 1, cancelToken: freshToken());

      expect(result, isA<IsError<List<Planet>>>());
    });
  });

  group('getPlanetDetail', () {
    test('resolves films + residents concurrently', () async {
      final planet = fakePlanet(
        films: ['https://swapi.dev/api/films/1/'],
        residents: ['https://swapi.dev/api/people/1/'],
      );
      fakeDatasource.filmResult     = ok('A New Hope');
      fakeDatasource.residentResult = ok('Luke Skywalker');

      final result = await repository.getPlanetDetail(
          planet: planet, cancelToken: freshToken());

      final detail = (result as IsSuccess<Planet>).model!;
      expect(detail.films, equals(['A New Hope']));
      expect(detail.residents, equals(['Luke Skywalker']));
    });

    test('empty residents — no resident calls made', () async {
      final planet = fakePlanet(residents: []);

      await repository.getPlanetDetail(
          planet: planet, cancelToken: freshToken());

      expect(fakeDatasource.getResidentCalls, equals(0));
    });

    test('failed resident fetch filtered — IsSuccess still returned', () async {
      fakeDatasource.residentResult =
          IsError(const TimeoutException());

      final result = await repository.getPlanetDetail(
          planet: fakePlanet(), cancelToken: freshToken());

      expect(result, isA<IsSuccess<Planet>>());
      final detail = (result as IsSuccess<Planet>).model!;
      expect(detail.residents, isEmpty);
    });

    test('all fetches fail — IsSuccess with empty lists', () async {
      fakeDatasource.filmResult     = IsError(const TimeoutException());
      fakeDatasource.residentResult = IsError(const TimeoutException());

      final result = await repository.getPlanetDetail(
          planet: fakePlanet(), cancelToken: freshToken());

      expect(result, isA<IsSuccess<Planet>>());
    });
  });
}
