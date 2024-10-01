import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_weather_bloc/domain/models/network_exception.dart';
import 'package:flutter_simple_weather_bloc/domain/repositories/geo_repository.dart';
import 'package:flutter_simple_weather_bloc/domain/repositories/weather_repository.dart';
import 'package:flutter_simple_weather_bloc/presentation/current_weather_state.dart';
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
        final weather = await weatherRepository.getCurrentWeather(
          long: position.longitude,
          lat: position.latitude,
        );
        log("weather temp ${weather.main.temp}");
        emit(state.copyWith(weather: weather));
      } on NetworkException catch (error) {
        emit(state.copyWith(errorMessage: error.message));
      } catch (e) {
        emit(state.copyWith(errorMessage: "$e"));
      } finally {
        log("finally");
        emit(state.copyWith(
            isLoading: false,
            needRequest: false,
            errorMessage: state.errorMessage));
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

  @override
  Future<void> close() {
    _permissionSubscription?.cancel();
    return super.close();
  }
}
