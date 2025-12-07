import '../../core/models/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(double lat, double lon, {String? cityName});
  Future<Weather> getCurrentWeatherByCity(String city);
}

