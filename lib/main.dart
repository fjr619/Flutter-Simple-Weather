import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_weather_bloc/di/injectable.dart';
import 'package:flutter_simple_weather_bloc/domain/repositories/geo_repository.dart';
import 'package:flutter_simple_weather_bloc/domain/repositories/weather_repository.dart';
import 'package:flutter_simple_weather_bloc/presentation/current_weather_screen.dart';
import 'package:flutter_simple_weather_bloc/presentation/current_weather_state.dart';

import 'presentation/current_weather_vm.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black38),
        useMaterial3: true,
      ),
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
