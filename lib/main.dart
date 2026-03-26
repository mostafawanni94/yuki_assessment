import 'package:flutter/material.dart';
import 'package:swapi_planets/app.dart';
import 'package:swapi_planets/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();
  runApp(const App());
}
