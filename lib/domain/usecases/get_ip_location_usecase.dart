import '../models/ip_location.dart';
import '../repositories/ip_geolocation_repository.dart';

class GetIpLocationUseCase {
  final IpGeolocationRepository repository;

  GetIpLocationUseCase(this.repository);

  Future<IpLocation> call({String? ip}) {
    if (ip != null) {
      return repository.getLocationByIp(ip: ip);
    }
    return repository.getCurrentIpInfo();
  }
}












