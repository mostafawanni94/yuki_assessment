import 'package:flutter/material.dart';
import 'package:swapi_planets/core/navigation/app_router.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'SWAPI Planets',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
      );
}
