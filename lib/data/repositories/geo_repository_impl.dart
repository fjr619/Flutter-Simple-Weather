import 'package:flutter_simple_weather_bloc/domain/repositories/geo_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GeoRepository)
class GeoRepositoryImpl extends GeoRepository {
  final GeolocatorPlatform geolocator;

  GeoRepositoryImpl(this.geolocator);

  @override
  Future<Position> getCurrentLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    return await geolocator.getCurrentPosition(
        locationSettings: locationSettings);
  }

  @override
  Stream<bool> getPermissionStatusStream() async* {
    // Emit initial permission status
    final initialPermission = await _checkPermission();
    yield _isPermissionGranted(initialPermission);

    // Listen to service status changes and recheck permission
    await for (final serviceStatus in _getServiceStatusStream()) {
      if (serviceStatus == ServiceStatus.enabled) {
        final permission = await _checkPermission();
        yield _isPermissionGranted(permission);
      } else {
        yield false; // Location services are disabled
      }
    }
  }

  Stream<ServiceStatus> _getServiceStatusStream() {
    return geolocator.getServiceStatusStream();
  }

  Future<LocationPermission> _checkPermission() async {
    return await geolocator.checkPermission();
  }

  // Helper method to check if permission is granted
  bool _isPermissionGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}
