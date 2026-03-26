import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/navigation/app_router.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Force dark status bar globally
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp.router(
        title: 'Star Wars Planets',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        routerConfig: appRouter,
        // i18n phase 2: add localizationsDelegates + supportedLocales here
      ),
    );
  }
}
