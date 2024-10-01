import 'package:dio/dio.dart';
import 'package:flutter_simple_weather_bloc/domain/models/current_weather.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoteDataSource {
  final Dio _dio;

  RemoteDataSource({required Dio dio}) : _dio = dio;

  Future<CurrentWeather> fetchWeatherByLocation({
    required double lat,
    required double long,
  }) {
    return _dio.get('weather', queryParameters: {
      "lat": lat,
      'lon': long,
      // 'exclude': 'minutely,hourly,daily,alerts',
      'units': 'metric',
      'appid': '2b6fcd74bb0f44c1e324f04ce938693c'
    }).then(
      (value) {
        return CurrentWeather.fromMap(value.data);
      },
    );
  }
}
