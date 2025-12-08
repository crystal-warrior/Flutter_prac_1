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
      // Очищаем название города от лишних пробелов
      final cleanCity = city.trim();
      print('Запрос погоды для города: "$cleanCity"');
      
      // Добавляем timestamp для предотвращения кэширования
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      final response = await _weatherApi.getCurrentWeatherByCity(
        cleanCity,
        'ru_RU',
        timestamp,
      );
      
      final geoObject = response['geo_object'] as Map<String, dynamic>?;
      final locality = geoObject?['locality'] as Map<String, dynamic>?;
      final returnedCity = locality?['name'] as String?;
      final info = response['info'] as Map<String, dynamic>?;
      final lat = info?['lat'];
      final lon = info?['lon'];
      print('Получен ответ для города "$cleanCity":');
      print('  - Возвращен город из API: ${returnedCity ?? "не указан"}');
      print('  - Координаты: lat=$lat, lon=$lon');
      print('  - geo_object присутствует: ${geoObject != null}');
      
      return WeatherDto.fromJson(response);
    } catch (e) {
      print('Ошибка при получении погоды для города "$city": $e');
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

  // Запрос 5: Сравнение погоды в разных городах (только Яндекс.Погода API)
  // Выполняет множественные запросы getCurrentWeatherByCity для каждого города
  Future<List<WeatherDto>> getWeatherComparison(List<String> cities) async {
    try {
      final List<WeatherDto> results = [];
      for (final city in cities) {
        // Используем только Яндекс.Погода API для каждого города
        final weather = await getCurrentWeatherByCity(city);
        results.add(weather);
      }
      return results;
    } catch (e) {
      rethrow;
    }
  }
}

