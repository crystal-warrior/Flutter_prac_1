import '../../core/models/location.dart';

abstract class LocationRepository {
  Future<Location> getCurrentLocation();
  Future<Location> getLocationByAddress(String address);
  Future<Location> getLocationByCity(String city);
}

