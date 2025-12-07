import '../../../core/network/dio_client.dart';
import '../../../core/network/api/weather_api.dart';
import 'dto/weather_dto.dart';

class WeatherDataSource {
  final DioClient _dioClient;
  late final WeatherApi _weatherApi;

  WeatherDataSource(this._dioClient) {

    _weatherApi = WeatherApi(_dioClient.dio);
  }


  Future<WeatherDto> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await _weatherApi.getCurrentWeather(
        lat.toString(),
        lon.toString(),
        'ru_RU',
      );
      return WeatherDto.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }


  Future<WeatherDto> getCurrentWeatherByCity(String city) async {
    try {
      final response = await _weatherApi.getCurrentWeatherByCity(
        city,
        'ru_RU',
      );
      return WeatherDto.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }


  Future<WeatherDto> getWeatherForecast(double lat, double lon, {int limit = 7}) async {
    try {
      final response = await _weatherApi.getWeatherForecast(
        lat.toString(),
        lon.toString(),
        'ru_RU',
        limit.toString(),
      );
      return WeatherDto.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Запрос 4: Погода на конкретную дату (для лунного календаря)
  Future<WeatherDto> getWeatherForDate(double lat, double lon, DateTime date) async {
    try {
      final response = await _dioClient.get(
        '/v2/forecast',
        queryParameters: {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'lang': 'ru_RU',
          'limit': '7',
        },
      );
      return WeatherDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Запрос 5: Сравнение погоды в разных городах
  Future<List<WeatherDto>> getWeatherComparison(List<String> cities) async {
    try {
      final List<WeatherDto> results = [];
      for (final city in cities) {
        final weather = await getCurrentWeatherByCity(city);
        results.add(weather);
      }
      return results;
    } catch (e) {
      rethrow;
    }
  }
}

