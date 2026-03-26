import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Centralised route configuration.
/// Routes will be added per feature branch during the assessment.
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      // Placeholder — replaced when planets feature is added.
      builder: (_, __) => const _PlaceholderScreen(),
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('swapi_planets — base project')),
      );
}
