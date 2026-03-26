import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/errors/timeout_exception.dart';
import 'package:swapi_planets/core/result/result.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/bloc/planet_detail_bloc.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/domain/repository/i_planets_repository.dart';

import '../../../core/test_helpers.dart';

// ─── Fake repository ──────────────────────────────────────────────────────────

class _FakeRepo extends Fake implements IPlanetsRepository {
  MyResult<PlanetModel> detailResult = ok(fakePlanet());

  @override
  Future<MyResult<List<PlanetModel>>> getPlanets({
    required int page,
    required CancelToken cancelToken,
  }) async =>
      ok([]);

  @override
  Future<MyResult<PlanetModel>> getPlanetDetail({
    required PlanetModel planet,
    required CancelToken cancelToken,
  }) async =>
      detailResult;
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late _FakeRepo fakeRepo;

  setUp(() => fakeRepo = _FakeRepo());

  group('PlanetDetailBloc', () {
    blocTest<PlanetDetailBloc, BaseState<PlanetModel>>(
      'loadDetail emits [loading, success] on success',
      build: () => PlanetDetailBloc(repository: fakeRepo),
      act: (bloc) => bloc.loadDetail(fakePlanet()),
      expect: () => [
        isA<Loading<PlanetModel>>(),
        isA<Success<PlanetModel>>(),
      ],
    );

    blocTest<PlanetDetailBloc, BaseState<PlanetModel>>(
      'loadDetail emits [loading, failure] on error',
      build: () => PlanetDetailBloc(repository: fakeRepo),
      setUp: () => fakeRepo.detailResult =
          const MyResult.isError(TimeoutException()),
      act: (bloc) => bloc.loadDetail(fakePlanet()),
      expect: () => [
        isA<Loading<PlanetModel>>(),
        isA<Failure<PlanetModel>>(),
      ],
    );

    blocTest<PlanetDetailBloc, BaseState<PlanetModel>>(
      'success state contains resolved planet data',
      build: () => PlanetDetailBloc(repository: fakeRepo),
      act: (bloc) async {
        fakeRepo.detailResult = ok(fakePlanet(
          name: 'Tatooine',
          films: ['A New Hope'],
          residents: ['Luke Skywalker'],
        ));
        await bloc.loadDetail(fakePlanet());
      },
      verify: (bloc) {
        final planet = bloc.state.model;
        expect(planet?.name, equals('Tatooine'));
        expect(planet?.films, equals(['A New Hope']));
        expect(planet?.residents, equals(['Luke Skywalker']));
      },
    );

    blocTest<PlanetDetailBloc, BaseState<PlanetModel>>(
      'failure state has retry callback wired',
      build: () => PlanetDetailBloc(repository: fakeRepo),
      setUp: () => fakeRepo.detailResult =
          const MyResult.isError(TimeoutException()),
      act: (bloc) => bloc.loadDetail(fakePlanet()),
      verify: (bloc) {
        expect(bloc.state, isA<Failure<PlanetModel>>());
        expect((bloc.state as Failure<PlanetModel>).retry, isNotNull);
      },
    );
  });
}
