import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_simple_weather_bloc/domain/models/current_weather.dart';
import 'package:flutter_simple_weather_bloc/domain/models/network_exception.dart';
import 'package:injectable/injectable.dart';
import '../../data/remote/remote_data_source.dart';

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl extends RemoteDataSource {
  final Dio _dio;

  RemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<CurrentWeather> fetchWeatherByLocation({
    required double lat,
    required double long,
  }) async {
    try {
      final result = await _dio.get('weather', queryParameters: {
        "lat": lat,
        'lon': long,
        // 'exclude': 'minutely,hourly,daily,alerts',
        'units': 'metric',
        'appid': dotenv.env['API_KEY']
      });
      return CurrentWeather.fromMap(result.data);
    } on DioException catch (error) {
      throw NetworkException(error.message ?? 'network error');
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
