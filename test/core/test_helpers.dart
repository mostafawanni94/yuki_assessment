import 'package:dio/dio.dart';
import 'package:swapi_planets/core/errors/bad_request_exception.dart';
import 'package:swapi_planets/core/errors/connection_exception.dart';
import 'package:swapi_planets/core/errors/not_found_exception.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/data/model/planet_dto.dart';
import 'package:swapi_planets/feature/planets/data/model/planets_page_dto.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

// ─── Entity fixtures ──────────────────────────────────────────────────────────

Planet fakePlanet({
  String name = 'Tatooine',
  String url = 'https://swapi.dev/api/planets/1/',
  List<String> films = const ['https://swapi.dev/api/films/1/'],
  List<String> residents = const ['https://swapi.dev/api/people/1/'],
}) =>
    Planet(
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
      url: url,
      created: '2014-12-09T13:50:49.641000Z',
      edited: '2014-12-20T20:58:18.411000Z',
    );

// ─── DTO fixtures ─────────────────────────────────────────────────────────────

PlanetDto fakePlanetDto({
  String name = 'Tatooine',
  String url = 'https://swapi.dev/api/planets/1/',
  List<String> filmUrls = const ['https://swapi.dev/api/films/1/'],
  List<String> residentUrls = const ['https://swapi.dev/api/people/1/'],
}) =>
    PlanetDto(
      name: name,
      rotationPeriod: '23',
      orbitalPeriod: '304',
      diameter: '10465',
      climate: 'arid',
      gravity: '1 standard',
      terrain: 'desert',
      surfaceWater: '1',
      population: '200000',
      filmUrls: filmUrls,
      residentUrls: residentUrls,
      url: url,
      created: '2014-12-09T13:50:49.641000Z',
      edited: '2014-12-20T20:58:18.411000Z',
    );

PlanetsPageDto fakePage({
  required List<PlanetDto> dtos,
  String? next,
}) =>
    PlanetsPageDto(
      count: dtos.length,
      next: next,
      previous: null,
      results: dtos,
    );

// ─── Result helpers ───────────────────────────────────────────────────────────

IsSuccess<T> ok<T>(T value) => IsSuccess<T>(value);
IsError<T> err<T>() => IsError<T>(const UnknownException());

const IsError<String> kTimeout    = IsError(TimeoutException());
const IsError<String> kNotFound   = IsError(NotFoundException());
const IsError<String> kNoConn     = IsError(ConnectionException());
const IsError<String> kBadRequest = IsError(BadRequestException(message: 'bad'));

CancelToken freshToken() => CancelToken();
