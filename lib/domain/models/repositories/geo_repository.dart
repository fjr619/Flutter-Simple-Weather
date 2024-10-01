import 'package:geolocator/geolocator.dart';

abstract class GeoRepository {
  Future<Position> getCurrentLocation();
  Stream<ServiceStatus> getServiceStatusStream();
  Future<LocationPermission> checkPermission();
  Stream<bool> getPermissionStatusStream();
}
