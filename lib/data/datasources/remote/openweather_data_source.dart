import '../../../core/network/dio_client.dart';
import 'dto/openweather_dto.dart';

class OpenWeatherDataSource {
  final DioClient _dioClient;

  OpenWeatherDataSource(this._dioClient);

  // Запрос 12: Получение текущей погоды по городу
  Future<OpenWeatherDto> getCurrentWeather({String? city}) async {
    try {
      final response = await _dioClient.get(
        '/weather',
        queryParameters: {
          'q': city ?? 'Moscow',
          'lang': 'ru',
          'units': 'metric', // Получаем температуру в Цельсиях напрямую
        },
      );
      print('🌤️ OpenWeatherMap ответ: ${response.data}');
      return OpenWeatherDto.fromJson(response.data);
    } catch (e) {
      print('❌ Ошибка OpenWeatherMap: $e');
      rethrow;
    }
  }

  // Запрос 13: Получение погоды по координатам
  Future<OpenWeatherDto> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dioClient.get(
        '/weather',
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'lang': 'ru',
          'units': 'metric', // Получаем температуру в Цельсиях напрямую
        },
      );
      print('🌤️ OpenWeatherMap ответ (координаты): ${response.data}');
      return OpenWeatherDto.fromJson(response.data);
    } catch (e) {
      print('❌ Ошибка OpenWeatherMap (координаты): $e');
      rethrow;
    }
  }
}












