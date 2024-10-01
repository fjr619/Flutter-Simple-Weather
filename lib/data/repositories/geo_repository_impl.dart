import 'package:flutter_simple_weather_bloc/domain/models/repositories/geo_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GeoRepository)
class GeoRepositoryImpl extends GeoRepository {
  final GeolocatorPlatform geolocator;

  GeoRepositoryImpl(this.geolocator);

  @override
  Future<Position> getCurrentLocation() async {
    return await geolocator.getCurrentPosition();
  }

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return geolocator.getServiceStatusStream();
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return await geolocator.checkPermission();
  }

  @override
  Stream<bool> getPermissionStatusStream() async* {
    // Emit initial permission status
    final initialPermission = await checkPermission();
    yield _isPermissionGranted(initialPermission);

    // Listen to service status changes and recheck permission
    await for (final serviceStatus in getServiceStatusStream()) {
      if (serviceStatus == ServiceStatus.enabled) {
        final permission = await checkPermission();
        yield _isPermissionGranted(permission);
      } else {
        yield false; // Location services are disabled
      }
    }
  }

  // Helper method to check if permission is granted
  bool _isPermissionGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}
