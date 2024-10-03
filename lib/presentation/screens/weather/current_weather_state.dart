// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/current_weather.dart';

@immutable
class CurrentWeatherState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final CurrentWeather? weather;
  final bool isPermissionGranted;
  final bool needRequest;
  const CurrentWeatherState(
      {this.isLoading = false,
      this.errorMessage,
      this.weather,
      this.isPermissionGranted = false,
      this.needRequest = true});

  CurrentWeatherState copyWith(
      {bool? isLoading,
      String? errorMessage,
      CurrentWeather? weather,
      bool? isPermissionGranted,
      bool? needRequest}) {
    return CurrentWeatherState(
        isLoading: isLoading ?? this.isLoading,
        // This line ensures that if `errorMessage` is explicitly set to `null`, it will not fallback to `this.errorMessage`.
        errorMessage:
            errorMessage ?? (errorMessage == null ? null : this.errorMessage),
        weather: weather ?? this.weather,
        isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
        needRequest: needRequest ?? this.needRequest);
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        weather,
        isPermissionGranted,
        needRequest,
      ];
}
