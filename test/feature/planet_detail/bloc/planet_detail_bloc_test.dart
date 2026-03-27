import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/bloc/planet_detail_bloc.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planet_detail_params.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planet_detail_usecase.dart';

import '../../../core/test_helpers.dart';

// ─── Fake UseCase ─────────────────────────────────────────────────────────────

class _FakeGetDetailUseCase extends Fake
    implements GetPlanetDetailUseCase {
  MyResult<Planet> result = ok(fakePlanet());

  @override
  Future<MyResult<Planet>> execute(GetPlanetDetailParams params) async =>
      result;
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late _FakeGetDetailUseCase fakeUseCase;

  setUp(() => fakeUseCase = _FakeGetDetailUseCase());

  group('PlanetDetailBloc', () {
    blocTest<PlanetDetailBloc, BaseState<Planet>>(
      'loadDetail emits [Loading, Success] on success',
      build: () => PlanetDetailBloc(useCase: fakeUseCase),
      act: (b) => b.loadDetail(fakePlanet()),
      expect: () => [
        isA<Loading<Planet>>(),
        isA<Success<Planet>>(),
      ],
    );

    blocTest<PlanetDetailBloc, BaseState<Planet>>(
      'loadDetail emits [Loading, Failure] on error',
      build: () => PlanetDetailBloc(useCase: fakeUseCase),
      setUp: () => fakeUseCase.result =
          IsError(const TimeoutException()),
      act: (b) => b.loadDetail(fakePlanet()),
      expect: () => [
        isA<Loading<Planet>>(),
        isA<Failure<Planet>>(),
      ],
    );

    blocTest<PlanetDetailBloc, BaseState<Planet>>(
      'success state contains resolved Planet data',
      build: () => PlanetDetailBloc(useCase: fakeUseCase),
      act: (b) async {
        fakeUseCase.result = ok(fakePlanet(
          name: 'Tatooine',
          films: ['A New Hope'],
          residents: ['Luke Skywalker'],
        ));
        await b.loadDetail(fakePlanet());
      },
      verify: (b) {
        final p = b.state.model!;
        expect(p.name, equals('Tatooine'));
        expect(p.films, equals(['A New Hope']));
        expect(p.residents, equals(['Luke Skywalker']));
      },
    );

    blocTest<PlanetDetailBloc, BaseState<Planet>>(
      'failure state has retry callback wired',
      build: () => PlanetDetailBloc(useCase: fakeUseCase),
      setUp: () => fakeUseCase.result =
          IsError(const TimeoutException()),
      act: (b) => b.loadDetail(fakePlanet()),
      verify: (b) {
        expect(b.state, isA<Failure<Planet>>());
        expect((b.state as Failure<Planet>).retry, isNotNull);
      },
    );
  });
}
