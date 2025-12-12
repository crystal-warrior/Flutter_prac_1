import '../models/openweather_weather.dart';

abstract class OpenWeatherRepository {
  Future<OpenWeatherWeather> getCurrentWeather({String? city});
  Future<OpenWeatherWeather> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  });
}










