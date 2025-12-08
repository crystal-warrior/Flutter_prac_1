import '../../core/models/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<Weather> call(double lat, double lon, {String? cityName}) {
    return repository.getCurrentWeather(lat, lon, cityName: cityName);
  }

  Future<Weather> callByCity(String city) {
    return repository.getCurrentWeatherByCity(city);
  }

  Future<List<Weather>> getForecast(double lat, double lon, {int limit = 7, String? cityName}) {
    return repository.getWeatherForecast(lat, lon, limit: limit, cityName: cityName);
  }

  Future<Weather?> getForDate(double lat, double lon, DateTime date, {String? cityName}) {
    return repository.getWeatherForDate(lat, lon, date, cityName: cityName);
  }

  Future<List<Weather>> compareCities(List<String> cities) {
    return repository.getWeatherComparison(cities);
  }
}

