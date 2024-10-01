import 'package:geolocator/geolocator.dart';

abstract class GeoRepository {
  Future<Position> getCurrentLocation();

  Stream<bool> getPermissionStatusStream();
}
