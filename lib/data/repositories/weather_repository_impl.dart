import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_simple_weather_bloc/data/remote/remote_data_source.dart';
import 'package:flutter_simple_weather_bloc/domain/models/current_weather.dart';
import 'package:flutter_simple_weather_bloc/domain/models/failure.dart';
import 'package:flutter_simple_weather_bloc/domain/models/network_exception.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/weather_repository.dart';

@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl extends WeatherRepository {
  final RemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CurrentWeather>> getCurrentWeather(
      {required double long, required double lat}) async {
    try {
      final response =
          await remoteDataSource.fetchWeatherByLocation(lat: lat, long: long);
      return Right(response);
    } on NetworkException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }
}
