// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:geolocator/geolocator.dart' as _i699;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/repositories/geo_repository_impl.dart' as _i909;
import '../domain/models/repositories/geo_repository.dart' as _i919;
import '../presentation/current_weather_vm.dart' as _i595;
import 'injectable.dart' as _i1027;

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
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i699.GeolocatorPlatform>(() => registerModule.geolocator);
    gh.lazySingleton<_i919.GeoRepository>(
        () => _i909.GeoRepositoryImpl(gh<_i699.GeolocatorPlatform>()));
    gh.factory<_i595.CurrentWeatherVm>(
        () => _i595.CurrentWeatherVm(geoRepository: gh<_i919.GeoRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i1027.RegisterModule {}
