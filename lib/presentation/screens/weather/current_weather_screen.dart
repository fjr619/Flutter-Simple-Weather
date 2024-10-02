import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_weather_bloc/presentation/screens/weather/current_weather_state.dart';
import 'package:flutter_simple_weather_bloc/presentation/screens/weather/current_weather_vm.dart';
import 'package:lottie/lottie.dart';

/*
  please add logic to handle permission request!!
*/

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Optionally, make the status bar and navigation bar transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      systemNavigationBarColor:
          Colors.transparent, // Transparent navigation bar
    ));
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
      body: BlocBuilder<CurrentWeatherVm, CurrentWeatherState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration:
                const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _buildContent(context, state),
          );
        },
      ),
    );
  }

  // Method to build the content depending on the state
  Widget _buildContent(BuildContext context, CurrentWeatherState state) {
    if (state.isLoading) {
      return Center(
        child: LottieBuilder.asset(
          'assets/loading.json',
          key: const ValueKey('loading'), // Key for the loading state
        ),
      );
    } else if (state.errorMessage != null) {
      return Center(
        child: Text(
          state.errorMessage!,
          key: const ValueKey('errorMessage'), // Key for the error state
        ),
      );
    } else if (state.weather != null) {
      return Center(
        key: const ValueKey('weatherData'), // Key for the weather content state
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.place,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // City name
                Text(
                  '${state.weather?.name}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            // Animation
            Lottie.asset(
              context.read<CurrentWeatherVm>().getWeatherAnimation(),
            ),
            Column(
              children: [
                // Temperature
                Text(
                  '${state.weather?.main?.temp?.round()}°C',
                  style: TextStyle(
                    fontSize: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // Weather condition
                Text(
                  '${state.weather?.weather?[0].main}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        'No weather data available.',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        key: const ValueKey('noData'), // Key for the no data state
      ),
    );
  }
}
