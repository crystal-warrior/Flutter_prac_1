import '../../../core/network/dio_client.dart';
import '../../../core/network/api/ip_geolocation_api.dart';
import 'dto/ip_geolocation_dto.dart';

class IpGeolocationDataSource {
  final DioClient _dioClient;
  late final IpGeolocationApi _ipGeolocationApi;
  static const String _fields = 'status,message,country,countryCode,region,regionName,city,lat,lon,timezone,query';

  IpGeolocationDataSource(this._dioClient) {
    // Используем Dio из DioClient для создания Retrofit API
    _ipGeolocationApi = IpGeolocationApi(_dioClient.dio);
  }

  // Запрос 10: Получение информации о местоположении по IP адресу
  Future<IpGeolocationDto> getLocationByIp({String? ip}) async {
    try {
      final response = ip != null
          ? await _ipGeolocationApi.getLocationByIp(ip, _fields)
          : await _ipGeolocationApi.getCurrentLocation(_fields);
      return IpGeolocationDto.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Запрос 11: Получение информации о текущем IP
  Future<IpGeolocationDto> getCurrentIpInfo() async {
    try {
      final response = await _ipGeolocationApi.getCurrentLocation(_fields);
      return IpGeolocationDto.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}



