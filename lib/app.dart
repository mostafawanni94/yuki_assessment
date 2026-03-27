import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:swapi_planets/core/connectivity/connectivity_cubit.dart';
import 'package:swapi_planets/core/navigation/app_router.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';
import 'package:swapi_planets/core/theme/theme_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Restore persisted theme on startup
    GetIt.I<ThemeCubit>().loadSavedTheme();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    // Both cubits are singletons in GetIt — BlocProvider.value shares them
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: GetIt.I<ThemeCubit>()),
        BlocProvider.value(value: GetIt.I<ConnectivityCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, AppColorScheme>(
        builder: (_, colorScheme) => ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) => MaterialApp.router(
            title: 'Star Wars Planets',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.from(colorScheme),
            routerConfig: appRouter,
          ),
        ),
      ),
    );
  }
}
