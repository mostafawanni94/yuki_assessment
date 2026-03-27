import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/screen/planet_detail_screen.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/presentation/screen/planets_list_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// All app routes — one entry per feature branch.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: PlanetsListScreen.route,
  routes: [
    GoRoute(
      path: PlanetsListScreen.route,
      builder: (_, __) => const PlanetsListScreen(),
    ),
    GoRoute(
      path: PlanetDetailScreen.route,
      builder: (context, state) {
        // Planet passed via extra — type-safe, no serialisation needed
        final planet = state.extra as Planet;
        return PlanetDetailScreen(planet: planet);
      },
    ),
  ],
);
