import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'ip_geolocation_api.g.dart';

@RestApi()
abstract class IpGeolocationApi {
  factory IpGeolocationApi(Dio dio, {String baseUrl}) = _IpGeolocationApi;

  @GET('/json/{ip}')
  Future<Map<String, dynamic>> getLocationByIp(
    @Path('ip') String ip,
    @Query('fields') String fields,
  );


  @GET('/json/')
  Future<Map<String, dynamic>> getCurrentLocation(
    @Query('fields') String fields,
  );
}

