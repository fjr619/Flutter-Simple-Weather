import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_weather_bloc/domain/models/failure.dart';
import 'package:flutter_simple_weather_bloc/domain/models/network_exception.dart';
import 'package:flutter_simple_weather_bloc/domain/repositories/geo_repository.dart';
import 'package:flutter_simple_weather_bloc/domain/repositories/weather_repository.dart';
import 'package:flutter_simple_weather_bloc/presentation/screens/weather/current_weather_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentWeatherVm extends Cubit<CurrentWeatherState> {
  final GeoRepository geoRepository;
  final WeatherRepository weatherRepository;

  StreamSubscription<bool>? _permissionSubscription;

  CurrentWeatherVm({
    required this.geoRepository,
    required this.weatherRepository,
  }) : super(const CurrentWeatherState());

  Future<void> fetchWeatherData() async {
    if (!state.isPermissionGranted) {
      return emit(state.copyWith(errorMessage: "permission denied"));
    }
    if (state.needRequest) {
      try {
        emit(state.copyWith(isLoading: true));
        final position = await geoRepository.getCurrentLocation();
        log('position ${position.latitude} ${position.longitude}');
        await Future.delayed(const Duration(seconds: 2));
        final result = await weatherRepository.getCurrentWeather(
          long: position.longitude,
          lat: position.latitude,
        );

        result.fold(
          (failure) {
            if (failure is ServerFailure) {
              emit(state.copyWith(
                  errorMessage: failure.errorMessage, isLoading: false));
            }
          },
          (data) {
            emit(state.copyWith(
                weather: data, isLoading: false, needRequest: false));
          },
        );
      } catch (e) {
        emit(state.copyWith(errorMessage: "$e", isLoading: false));
      }
    }
  }

  void listenToPermissionChanges() {
    log('listenToPermissionChanges start');
    _permissionSubscription?.cancel();

    // Listen to the permission status stream
    _permissionSubscription = geoRepository.getPermissionStatusStream().listen(
      (isGranted) {
        if (isGranted) {
          log('isgranted');
          emit(state.copyWith(isPermissionGranted: true));
          log('Permission granted, ready to fetch weather ${state.isPermissionGranted}');
          fetchWeatherData(); // Optionally fetch weather if permission is granted
        } else {
          log('not granted');
          emit(state.copyWith(
              isPermissionGranted: false, errorMessage: "permission denied"));
        }
      },
    );
  }

  String getWeatherAnimation() {
    final condition = state.weather?.weather?[0].main;
    log('condition $condition');
    if (condition == null) {
      return 'assets/sunny.json';
    }

    switch (condition.toLowerCase()) {
      case 'clounds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Future<void> close() {
    _permissionSubscription?.cancel();
    return super.close();
  }
}
