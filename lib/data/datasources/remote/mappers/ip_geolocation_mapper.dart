import '../../../../domain/models/ip_location.dart';
import '../dto/ip_geolocation_dto.dart';

extension IpGeolocationMapper on IpGeolocationDto {
  IpLocation toDomain() {
    return IpLocation(
      country: country ?? 'Неизвестно',
      countryCode: countryCode ?? '',
      region: region ?? '',
      regionName: regionName ?? 'Неизвестно',
      city: city ?? 'Неизвестно',
      latitude: lat ?? 0.0,
      longitude: lon ?? 0.0,
      timezone: timezone ?? '',
    );
  }
}






