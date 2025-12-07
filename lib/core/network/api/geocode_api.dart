import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'geocode_api.g.dart';

@RestApi()
abstract class GeocodeApi {
  factory GeocodeApi(Dio dio, {String baseUrl}) = _GeocodeApi;


  @GET('/1.x/')
  Future<Map<String, dynamic>> geocode(
    @Query('geocode') String geocode,
    @Query('format') String format,
    @Query('results') int results,
    @Query('apikey') String apikey,
  );

  @GET('/1.x/')
  Future<Map<String, dynamic>> reverseGeocode(
    @Query('geocode') String address,
    @Query('format') String format,
    @Query('results') int results,
    @Query('apikey') String apikey,
  );
}

