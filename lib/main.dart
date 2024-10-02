import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_simple_weather_bloc/di/injectable.dart';
import 'package:flutter_simple_weather_bloc/domain/repositories/geo_repository.dart';
import 'package:flutter_simple_weather_bloc/domain/repositories/weather_repository.dart';
import 'package:flutter_simple_weather_bloc/presentation/screens/weather/current_weather_screen.dart';
import 'package:flutter_simple_weather_bloc/presentation/theme/dark.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/screens/weather/current_weather_vm.dart';

void main() async {
  configureDependencies();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: darkMode.copyWith(
          textTheme:
              GoogleFonts.bebasNeueTextTheme(Theme.of(context).textTheme)),
      home: BlocProvider(
          create: (context) {
            final weatherVm = CurrentWeatherVm(
                weatherRepository: getIt<WeatherRepository>(),
                geoRepository: getIt<GeoRepository>())
              ..listenToPermissionChanges(); // Start listening to permission changes
            return weatherVm;
          },
          child: const WeatherPage()),
    );
  }
}
