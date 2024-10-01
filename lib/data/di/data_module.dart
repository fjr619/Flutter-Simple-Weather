import 'dart:developer';

import 'package:dio/dio.dart';
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
        baseUrl: 'https://api.openweathermap.org/data/2.5/',
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onError: (DioException error, handler) {
            // Handle different types of errors
            String errorMessage = handleDioError(error);
            log('Error occurred: $errorMessage');

            // Optionally modify the error before passing it back to the caller
            error.copyWith(message: errorMessage);
            return handler.next(error);
          },
        ),
      );

    return dio;
  }
}
