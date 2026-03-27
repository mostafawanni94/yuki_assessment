import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planets_params.dart';
import 'package:swapi_planets/feature/planets/domain/usecase/get_planets_usecase.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_bloc.dart';

import '../../../core/test_helpers.dart';

// ─── Fake UseCase ─────────────────────────────────────────────────────────────

class _FakeGetPlanetsUseCase extends Fake implements GetPlanetsUseCase {
  MyResult<List<Planet>> response = ok([fakePlanet()]);

  @override
  Future<MyResult<List<Planet>>> execute(GetPlanetsParams params) async =>
      response;
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late _FakeGetPlanetsUseCase fakeUseCase;

  setUp(() => fakeUseCase = _FakeGetPlanetsUseCase());

  group('PlanetsBloc', () {
    blocTest<PlanetsBloc, BaseState<List<Planet>>>(
      'loadPlanets emits [Loading, Success] on success',
      build: () => PlanetsBloc(getPlanetsUseCase: fakeUseCase),
      act: (b) => b.loadPlanets(),
      expect: () => [
        isA<Loading<List<Planet>>>(),
        isA<Success<List<Planet>>>(),
      ],
    );

    blocTest<PlanetsBloc, BaseState<List<Planet>>>(
      'loadPlanets emits [Loading, Failure] on error',
      build: () => PlanetsBloc(getPlanetsUseCase: fakeUseCase),
      setUp: () => fakeUseCase.response =
          IsError(const TimeoutException()),
      act: (b) => b.loadPlanets(),
      expect: () => [
        isA<Loading<List<Planet>>>(),
        isA<Failure<List<Planet>>>(),
      ],
    );

    blocTest<PlanetsBloc, BaseState<List<Planet>>>(
      'loadMore appends next page to existing list',
      build: () => PlanetsBloc(getPlanetsUseCase: fakeUseCase),
      act: (b) async {
        fakeUseCase.response =
            ok(List.generate(10, (i) => fakePlanet(name: 'P$i',
                url: 'https://swapi.dev/api/planets/$i/')));
        await b.loadPlanets();
        await b.loadMore();
      },
      verify: (b) => expect(b.state.model?.length, equals(20)),
    );

    blocTest<PlanetsBloc, BaseState<List<Planet>>>(
      'loadMore is no-op when hasMore is false',
      build: () => PlanetsBloc(getPlanetsUseCase: fakeUseCase),
      act: (b) async {
        fakeUseCase.response = ok([fakePlanet(), fakePlanet(
            name: 'B', url: 'https://swapi.dev/api/planets/2/')]);
        await b.loadPlanets();
        await b.loadMore(); // ignored
      },
      verify: (b) {
        expect(b.hasMore, isFalse);
        expect(b.state.model?.length, equals(2));
      },
    );

    blocTest<PlanetsBloc, BaseState<List<Planet>>>(
      'failure state contains correct error + retry callback',
      build: () => PlanetsBloc(getPlanetsUseCase: fakeUseCase),
      setUp: () => fakeUseCase.response =
          IsError(const TimeoutException()),
      act: (b) => b.loadPlanets(),
      verify: (b) {
        expect(b.state, isA<Failure<List<Planet>>>());
        expect(b.state.error, isA<TimeoutException>());
        expect((b.state as Failure).retry, isNotNull);
      },
    );

    blocTest<PlanetsBloc, BaseState<List<Planet>>>(
      'success state contains returned Planet entities',
      build: () => PlanetsBloc(getPlanetsUseCase: fakeUseCase),
      act: (b) async {
        fakeUseCase.response = ok([fakePlanet(name: 'Tatooine')]);
        await b.loadPlanets();
      },
      verify: (b) => expect(b.state.model?.first.name, equals('Tatooine')),
    );
  });
}
