import '../../core/models/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/weather_data_source.dart';
import '../datasources/remote/mappers/weather_mapper.dart';
import '../datasources/remote/location_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherDataSource _dataSource;
  final LocationDataSource? _locationDataSource;

  WeatherRepositoryImpl(this._dataSource, [this._locationDataSource]);

  @override
  Future<Weather> getCurrentWeather(double lat, double lon, {String? cityName}) async {
    final dto = await _dataSource.getCurrentWeather(lat, lon);
    return dto.toDomain(cityName: cityName);
  }

  @override
  Future<Weather> getCurrentWeatherByCity(String city) async {

    final locationDataSource = _locationDataSource;
    if (locationDataSource != null) {
      try {
        final location = await locationDataSource.getLocationByCity(city);
        print('Получены координаты для города "$city": ${location.latitude}, ${location.longitude}');

        final dto = await _dataSource.getCurrentWeather(location.latitude, location.longitude);
        return dto.toDomain(cityName: city);
      } catch (e) {

        print('Геокодирование не удалось для города "$city", используем прямой запрос: $e');
        final dto = await _dataSource.getCurrentWeatherByCity(city);
        return dto.toDomain(cityName: city);
      }
    } else {

      final dto = await _dataSource.getCurrentWeatherByCity(city);
      return dto.toDomain(cityName: city);
    }
  }

  @override
  Future<List<Weather>> getWeatherForecast(double lat, double lon, {int limit = 7, String? cityName}) async {
    final dto = await _dataSource.getWeatherForecast(lat, lon, limit: limit);
    return dto.toForecastList(cityName: cityName);
  }

  @override
  Future<Weather?> getWeatherForDate(double lat, double lon, DateTime date, {String? cityName}) async {
    final dto = await _dataSource.getWeatherForDate(lat, lon, date);
    return dto.getWeatherForDate(date, cityName: cityName);
  }

  @override
  Future<List<Weather>> getWeatherComparison(List<String> cities) async {
    // Используем метод getCurrentWeatherByCity, который использует геокодирование
    // для получения точных координат каждого города
    final List<Weather> results = [];
    
    for (final city in cities) {
      try {
        // Используем метод getCurrentWeatherByCity, который сначала получает координаты
        // через геокодирование, а затем запрашивает погоду по координатам
        final weather = await getCurrentWeatherByCity(city);
        results.add(weather);
      } catch (e) {
        // Если не удалось получить погоду для города, пропускаем его
        print('Ошибка при получении погоды для города $city: $e');
        continue;
      }
    }
    
    return results;
  }
}

