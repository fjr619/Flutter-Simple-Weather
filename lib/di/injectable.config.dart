// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:geolocator/geolocator.dart' as _i699;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/di/data_module.dart' as _i748;
import '../data/remote/remote_data_source.dart' as _i929;
import '../data/repositories/geo_repository_impl.dart' as _i909;
import '../data/repositories/weather_repository_impl.dart' as _i774;
import '../domain/repositories/geo_repository.dart' as _i112;
import '../domain/repositories/weather_repository.dart' as _i98;
import '../presentation/screens/weather/current_weather_vm.dart' as _i595;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dataModule = _$DataModule();
    gh.lazySingleton<_i699.GeolocatorPlatform>(() => dataModule.geolocator);
    gh.lazySingleton<_i361.Dio>(() => dataModule.provideDio());
    gh.lazySingleton<_i929.RemoteDataSource>(
        () => _i929.RemoteDataSource(dio: gh<_i361.Dio>()));
    gh.lazySingleton<_i112.GeoRepository>(
        () => _i909.GeoRepositoryImpl(gh<_i699.GeolocatorPlatform>()));
    gh.lazySingleton<_i98.WeatherRepository>(() => _i774.WeatherRepositoryImpl(
        remoteDataSource: gh<_i929.RemoteDataSource>()));
    gh.factory<_i595.CurrentWeatherVm>(() => _i595.CurrentWeatherVm(
          geoRepository: gh<_i112.GeoRepository>(),
          weatherRepository: gh<_i98.WeatherRepository>(),
        ));
    return this;
  }
}

class _$DataModule extends _i748.DataModule {}
