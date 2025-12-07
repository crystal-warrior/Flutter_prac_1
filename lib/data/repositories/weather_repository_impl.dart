import '../../core/models/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/weather_data_source.dart';
import '../datasources/remote/mappers/weather_mapper.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherDataSource _dataSource;

  WeatherRepositoryImpl(this._dataSource);

  @override
  Future<Weather> getCurrentWeather(double lat, double lon, {String? cityName}) async {
    final dto = await _dataSource.getCurrentWeather(lat, lon);
    return dto.toDomain(cityName: cityName);
  }

  @override
  Future<Weather> getCurrentWeatherByCity(String city) async {
    final dto = await _dataSource.getCurrentWeatherByCity(city);
    return dto.toDomain(cityName: city);
  }
}

