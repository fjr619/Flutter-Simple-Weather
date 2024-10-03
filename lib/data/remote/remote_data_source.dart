import 'package:flutter_simple_weather_bloc/domain/models/current_weather.dart';

abstract class RemoteDataSource {
  Future<CurrentWeather> fetchWeatherByLocation({
    required double lat,
    required double long,
  });
}
