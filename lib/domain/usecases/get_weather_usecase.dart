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
}

