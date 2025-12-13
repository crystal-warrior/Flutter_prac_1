import '../models/openweather_weather.dart';
import '../repositories/openweather_repository.dart';

class GetOpenWeatherUseCase {
  final OpenWeatherRepository repository;

  GetOpenWeatherUseCase(this.repository);

  Future<OpenWeatherWeather> call({String? city}) {
    return repository.getCurrentWeather(city: city);
  }

  Future<OpenWeatherWeather> callByCoordinates({
    required double latitude,
    required double longitude,
  }) {
    return repository.getWeatherByCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }
}











