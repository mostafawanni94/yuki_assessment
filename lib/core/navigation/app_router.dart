import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/screen/planet_detail_screen.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/presentation/screen/planets_list_screen.dart';

/// Navigation extra: planet + its list index (for consistent color).
typedef PlanetExtra = ({Planet planet, int index});

final GoRouter appRouter = GoRouter(
  initialLocation: PlanetsListScreen.route,
  routes: [
    GoRoute(
      path: PlanetsListScreen.route,
      builder: (_, __) => const PlanetsListScreen(),
    ),
    GoRoute(
      path: PlanetDetailScreen.route,
      builder: (_, state) {
        final extra = state.extra as PlanetExtra;
        return PlanetDetailScreen(
          planet: extra.planet,
          colorIndex: extra.index,
        );
      },
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    body: Center(child: Text('Route not found: ${state.error}')),
  ),
);
