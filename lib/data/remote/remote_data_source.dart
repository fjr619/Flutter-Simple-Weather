import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      'appid': dotenv.env['API_KEY']
    }).then(
      (value) {
        return CurrentWeather.fromMap(value.data);
      },
    );
  }
}
