import 'package:dartz/dartz.dart';
import 'package:flutter_simple_weather_bloc/domain/models/current_weather.dart';
import 'package:flutter_simple_weather_bloc/domain/models/failure.dart';

abstract class WeatherRepository {
  Future<Either<Failure, CurrentWeather>> getCurrentWeather(
      {required double long, required double lat});
}
