import 'package:dio/dio.dart';
import 'package:swapi_planets/core/errors/bad_request_exception.dart';
import 'package:swapi_planets/core/errors/connection_exception.dart';
import 'package:swapi_planets/core/errors/not_found_exception.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/domain/model/planets_page_model.dart';

// ─── Fixture factories ────────────────────────────────────────────────────────

/// Builds a minimal [PlanetModel] for tests.
PlanetModel fakePlanet({
  String name = 'Tatooine',
  List<String> films = const ['https://swapi.dev/api/films/1/'],
  List<String> residents = const ['https://swapi.dev/api/people/1/'],
}) =>
    PlanetModel(
      name: name,
      rotationPeriod: '23',
      orbitalPeriod: '304',
      diameter: '10465',
      climate: 'arid',
      gravity: '1 standard',
      terrain: 'desert',
      surfaceWater: '1',
      population: '200000',
      films: films,
      residents: residents,
      url: 'https://swapi.dev/api/planets/1/',
      created: '2014-12-09T13:50:49.641000Z',
      edited: '2014-12-20T20:58:18.411000Z',
    );

/// Builds a [PlanetsPageModel] wrapping [planets].
PlanetsPageModel fakePage({
  required List<PlanetModel> planets,
  String? next,
}) =>
    PlanetsPageModel(
      count: planets.length,
      next: next,
      previous: null,
      results: planets,
    );

// ─── Result factories ─────────────────────────────────────────────────────────

MyResult<T> ok<T>(T value) => MyResult.isSuccess(value);
MyResult<T> err<T>([Exception? _]) =>
    const MyResult.isError(UnknownException());

// ─── Common error results ─────────────────────────────────────────────────────

const MyResult<String> kTimeout =
    MyResult.isError(TimeoutException());
const MyResult<String> kNotFound =
    MyResult.isError(NotFoundException());
const MyResult<String> kNoConnection =
    MyResult.isError(ConnectionException());
const MyResult<String> kBadRequest =
    MyResult.isError(BadRequestException(message: 'bad'));

// ─── Cancel token ─────────────────────────────────────────────────────────────

CancelToken freshToken() => CancelToken();
