import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../util/util.dart';

@module
abstract class DataModule {
  @lazySingleton
  GeolocatorPlatform get geolocator => GeolocatorPlatform.instance;

  @lazySingleton
  Dio provideDio() {
    final dio = Dio()
      ..options = BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
      )
      ..interceptors.add(LogInterceptor(
        request: true, // Log request details
        requestHeader: true, // Log headers of requests
        requestBody: true, // Log request body
        responseHeader: true, // Log headers of responses
        responseBody: true, // Log response body
        error: true, // Log errors
        logPrint: (obj) => log('$obj'),
      ))
      ..interceptors.add(InterceptorsWrapper(
        onError: (DioException error, handler) {
          String errorMessage = handleDioError(error);
          return handler.next(error.copyWith(message: errorMessage));
        },
      ));

    return dio;
  }
}
