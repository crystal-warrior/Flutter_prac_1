import '../models/ip_location.dart';

abstract class IpGeolocationRepository {
  Future<IpLocation> getLocationByIp({String? ip});
  Future<IpLocation> getCurrentIpInfo();
}











