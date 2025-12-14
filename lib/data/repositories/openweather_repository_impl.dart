import '../../domain/models/openweather_weather.dart';
import '../../domain/repositories/openweather_repository.dart';
import '../datasources/remote/openweather_data_source.dart';
import '../datasources/remote/mappers/openweather_mapper.dart';

class OpenWeatherRepositoryImpl implements OpenWeatherRepository {
  final OpenWeatherDataSource _dataSource;

  OpenWeatherRepositoryImpl(this._dataSource);

  @override
  Future<OpenWeatherWeather> getCurrentWeather({String? city}) async {
    final dto = await _dataSource.getCurrentWeather(city: city);
    return dto.toDomain();
  }

  @override
  Future<OpenWeatherWeather> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final dto = await _dataSource.getWeatherByCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
    return dto.toDomain();
  }
}












