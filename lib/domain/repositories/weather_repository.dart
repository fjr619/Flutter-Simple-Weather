import 'package:flutter_simple_weather_bloc/domain/models/current_weather.dart';

abstract class WeatherRepository {
  Future<CurrentWeather> getCurrentWeather(
      {required double long, required double lat});
}
