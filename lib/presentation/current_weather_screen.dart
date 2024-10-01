import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_weather_bloc/presentation/current_weather_state.dart';
import 'package:flutter_simple_weather_bloc/presentation/current_weather_vm.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // Listen for lifecycle changes (like when app is resumed)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check permission when the app is resumed
      context.read<CurrentWeatherVm>().listenToPermissionChanges();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Weather'),
      ),
      body: BlocBuilder<CurrentWeatherVm, CurrentWeatherState>(
        builder: (context, state) {
          log('state ${state.isPermissionGranted} ${state.errorMessage}');
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          } else if (state.weather != null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("permission ok, get weather")],
              ),
            );
          }
          return const Center(child: Text('No weather data available.'));
        },
      ),
    );
  }
}
