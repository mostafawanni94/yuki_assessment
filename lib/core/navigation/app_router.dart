import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swapi_planets/feature/planets/presentation/screen/planets_list_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// App-wide route configuration.
/// Routes added per branch — each branch adds its own GoRoute entry.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: PlanetsListScreen.route,
  routes: [
    GoRoute(
      path: PlanetsListScreen.route,
      builder: (_, __) => const PlanetsListScreen(),
    ),
    // Planet detail route added in feat/planet-detail branch
  ],
);
