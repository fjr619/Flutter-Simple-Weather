import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_weather_bloc/domain/models/repositories/geo_repository.dart';
import 'package:flutter_simple_weather_bloc/presentation/current_weather_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurrentWeatherVm extends Cubit<CurrentWeatherState> {
  final GeoRepository geoRepository;
  StreamSubscription<bool>? _permissionSubscription;

  CurrentWeatherVm({required this.geoRepository})
      : super(const CurrentWeatherState());

  Future<void> fetchWeatherData() async {
    if (!state.isPermissionGranted) {
      return emit(state.copyWith(errorMessage: "permission denied"));
    }
    if (state.needRequest) {
      try {
        emit(state.copyWith(isLoading: true));
        final position = await geoRepository.getCurrentLocation();
        log('position ${position.altitude} ${position.longitude}');
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        emit(state.copyWith(errorMessage: "$e"));
      } finally {
        emit(state.copyWith(isLoading: false, needRequest: false));
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
