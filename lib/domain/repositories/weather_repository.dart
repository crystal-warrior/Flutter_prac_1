import '../../core/models/weather.dart';
import '../../core/models/weather_forecast.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(double lat, double lon, {String? cityName});
  Future<Weather> getCurrentWeatherByCity(String city);
  Future<List<Weather>> getWeatherForecast(double lat, double lon, {int limit = 7, String? cityName});
  Future<Weather?> getWeatherForDate(double lat, double lon, DateTime date, {String? cityName});
  Future<List<Weather>> getWeatherComparison(List<String> cities);
}

