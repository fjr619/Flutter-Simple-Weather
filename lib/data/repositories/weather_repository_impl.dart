import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_simple_weather_bloc/data/remote/remote_data_source.dart';
import 'package:flutter_simple_weather_bloc/domain/models/current_weather.dart';
import 'package:flutter_simple_weather_bloc/domain/models/network_exception.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/weather_repository.dart';

@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl extends WeatherRepository {
  final RemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CurrentWeather> getCurrentWeather(
      {required double long, required double lat}) async {
    try {
      final response =
          await remoteDataSource.fetchWeatherByLocation(lat: lat, long: long);
      return response;
    } on DioException catch (error) {
      throw NetworkException(error.message ?? 'network error');
    } catch (e) {
      log("-- e $e");
      throw NetworkException(e.toString());
    }
  }
}
