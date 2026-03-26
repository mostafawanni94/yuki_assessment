import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_bloc.dart';

import '../../../core/test_helpers.dart';

// ─── Fake repository ──────────────────────────────────────────────────────────

class _FakeRepo extends Fake implements IPlanetsRepository {
  MyResult<List<PlanetModel>> response =
      ok([fakePlanet()]);

  @override
  Future<MyResult<List<PlanetModel>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) async =>
      response;

  @override
  Future<MyResult<PlanetModel>> getPlanetDetail({
    required PlanetModel planet,
    required CancelToken cancelToken,
  }) async =>
      ok(planet);
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late _FakeRepo fakeRepo;

  setUp(() => fakeRepo = _FakeRepo());

  group('PlanetsBloc', () {
    // ─── loadPlanets ────────────────────────────────────────────────────────

    blocTest<PlanetsBloc, BaseState<List<PlanetModel>>>(
      'loadPlanets emits [loading, success] on success',
      build: () => PlanetsBloc(repository: fakeRepo),
      act: (bloc) => bloc.loadPlanets(),
      expect: () => [
        isA<Loading<List<PlanetModel>>>(),
        isA<Success<List<PlanetModel>>>(),
      ],
    );

    blocTest<PlanetsBloc, BaseState<List<PlanetModel>>>(
      'loadPlanets emits [loading, failure] on error',
      build: () => PlanetsBloc(repository: fakeRepo),
      setUp: () => fakeRepo.response =
          IsError(TimeoutException()),
      act: (bloc) => bloc.loadPlanets(),
      expect: () => [
        isA<Loading<List<PlanetModel>>>(),
        isA<Failure<List<PlanetModel>>>(),
      ],
    );

    blocTest<PlanetsBloc, BaseState<List<PlanetModel>>>(
      'loadPlanets resets and refetches page 1',
      build: () => PlanetsBloc(repository: fakeRepo),
      act: (bloc) async {
        fakeRepo.response = ok(List.generate(10, (_) => fakePlanet()));
        await bloc.loadPlanets();
        // Load more to get to page 2
        await bloc.loadMore();
        // Now refresh — should reset to page 1
        await bloc.loadPlanets();
      },
      verify: (bloc) => expect(bloc.currentPage, equals(2)),
    );

    // ─── loadMore ───────────────────────────────────────────────────────────

    blocTest<PlanetsBloc, BaseState<List<PlanetModel>>>(
      'loadMore appends next page to existing list',
      build: () => PlanetsBloc(repository: fakeRepo),
      act: (bloc) async {
        fakeRepo.response = ok(List.generate(10, (i) =>
            fakePlanet(name: 'Planet $i')));
        await bloc.loadPlanets();   // page 1 → 10 planets
        await bloc.loadMore();      // page 2 → 10 more
      },
      verify: (bloc) {
        final planets = bloc.state.model ?? [];
        expect(planets.length, equals(20));
      },
    );

    blocTest<PlanetsBloc, BaseState<List<PlanetModel>>>(
      'loadMore does nothing when hasMore is false',
      build: () => PlanetsBloc(repository: fakeRepo),
      act: (bloc) async {
        // Fewer than 10 results → hasMore = false
        fakeRepo.response = ok([fakePlanet(), fakePlanet()]);
        await bloc.loadPlanets();
        await bloc.loadMore();  // should be ignored
      },
      verify: (bloc) {
        expect(bloc.hasMore, isFalse);
        final planets = bloc.state.model ?? [];
        expect(planets.length, equals(2)); // still only 2, not doubled
      },
    );

    // ─── success model ───────────────────────────────────────────────────────

    blocTest<PlanetsBloc, BaseState<List<PlanetModel>>>(
      'success state contains the returned planets',
      build: () => PlanetsBloc(repository: fakeRepo),
      act: (bloc) async {
        fakeRepo.response = ok([fakePlanet(name: 'Tatooine')]);
        await bloc.loadPlanets();
      },
      verify: (bloc) {
        final planets = bloc.state.model;
        expect(planets?.first.name, equals('Tatooine'));
      },
    );

    // ─── failure state ───────────────────────────────────────────────────────

    blocTest<PlanetsBloc, BaseState<List<PlanetModel>>>(
      'failure state contains error and retry callback',
      build: () => PlanetsBloc(repository: fakeRepo),
      setUp: () => fakeRepo.response =
          IsError(TimeoutException()),
      act: (bloc) => bloc.loadPlanets(),
      verify: (bloc) {
        final state = bloc.state;
        expect(state, isA<Failure<List<PlanetModel>>>());
        expect(state.error, isA<TimeoutException>());
        expect((state as Failure).retry, isNotNull);
      },
    );
  });
}
