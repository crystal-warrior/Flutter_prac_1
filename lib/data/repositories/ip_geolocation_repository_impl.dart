import '../../domain/models/ip_location.dart';
import '../../domain/repositories/ip_geolocation_repository.dart';
import '../datasources/remote/ip_geolocation_data_source.dart';
import '../datasources/remote/mappers/ip_geolocation_mapper.dart';

class IpGeolocationRepositoryImpl implements IpGeolocationRepository {
  final IpGeolocationDataSource _dataSource;

  IpGeolocationRepositoryImpl(this._dataSource);

  @override
  Future<IpLocation> getLocationByIp({String? ip}) async {
    final dto = await _dataSource.getLocationByIp(ip: ip);
    return dto.toDomain();
  }

  @override
  Future<IpLocation> getCurrentIpInfo() async {
    final dto = await _dataSource.getCurrentIpInfo();
    return dto.toDomain();
  }
}





