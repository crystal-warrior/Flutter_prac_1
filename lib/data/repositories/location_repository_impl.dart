import '../../core/models/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/remote/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<Location> getCurrentLocation() async {
    return await _dataSource.getCurrentLocation();
  }

  @override
  Future<Location> getLocationByAddress(String address) async {
    return await _dataSource.getLocationByAddress(address);
  }

  @override
  Future<Location> getLocationByCity(String city) async {
    return await _dataSource.getLocationByCity(city);
  }
}

