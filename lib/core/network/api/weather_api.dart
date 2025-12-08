import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'weather_api.g.dart';

@RestApi()
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;


  @GET('/v2/forecast')
  Future<Map<String, dynamic>> getCurrentWeather(
    @Query('lat') String lat,
    @Query('lon') String lon,
    @Query('lang') String lang,
  );


  @GET('/v2/forecast')
  Future<Map<String, dynamic>> getCurrentWeatherByCity(
    @Query('city') String city,
    @Query('lang') String lang,
    @Query('_') String? timestamp,
  );


  @GET('/v2/forecast')
  Future<Map<String, dynamic>> getWeatherForecast(
    @Query('lat') String lat,
    @Query('lon') String lon,
    @Query('lang') String lang,
    @Query('limit') String limit,
  );
}

