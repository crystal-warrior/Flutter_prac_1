import 'package:geolocator/geolocator.dart';
import '../../../core/models/location.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/api/geocode_api.dart';

class LocationDataSource {
  final DioClient? _dioClient;
  GeocodeApi? _geocodeApi;
  static const String _geocodeApiKey = '93570217-87a3-4b40-a913-552c85a611fa';

  LocationDataSource([this._dioClient]) {
    if (_dioClient != null) {

      _geocodeApi = GeocodeApi(_dioClient.dio);
    }
  }


  Future<Location> getCurrentLocation() async {
    try {

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Служба геолокации отключена');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Разрешение на геолокацию отклонено');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Разрешение на геолокацию отклонено навсегда');
      }

      // Получаем текущую позицию
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Получаем адрес через Яндекс Geocoding API
      String? address;
      String? city;
      String? region;

      if (_geocodeApi != null) {
        try {
          // Используем Retrofit API для геокодирования
          final response = await _geocodeApi!.geocode(
            '${position.longitude},${position.latitude}',
            'json',
            1,
            _geocodeApiKey,
          );

          final responseData = response;
          final geoObjectCollection = responseData['response']?['GeoObjectCollection'];
          final features = geoObjectCollection?['featureMember'] as List?;
          
          if (features != null && features.isNotEmpty) {
            final feature = features[0];
            final geoObject = feature['GeoObject'];
            final metaData = geoObject['metaDataProperty']?['GeocoderMetaData'];
            
            // Полный адрес
            address = metaData?['text'] as String?;
            
            // Парсим компоненты адреса
            final addressData = metaData?['Address'];
            final components = addressData?['Components'] as List?;
            
            if (components != null) {
              for (var component in components) {
                final kind = component['kind'] as String?;
                final name = component['name'] as String?;
                
                if (kind == 'locality' && name != null) {
                  city = name;
                } else if (kind == 'province' && name != null) {
                  region = name;
                } else if (kind == 'area' && name != null && region == null) {
                  // Если нет province, используем area
                  region = name;
                }
              }
            }
            
            // Если город не найден в компонентах, попробуем извлечь из адреса
            if (city == null && address != null) {
              // Простая логика: если адрес содержит известные города
              final addressLower = address.toLowerCase();
              if (addressLower.contains('москва')) {
                city = 'Москва';
              } else if (addressLower.contains('санкт-петербург') || addressLower.contains('спб')) {
                city = 'Санкт-Петербург';
              }
            }
            
            // Отладочный вывод
            print('Геокодирование успешно:');
            print('  Адрес: $address');
            print('  Город: $city');
            print('  Регион: $region');
          }
        } catch (e) {
          // Если не удалось получить адрес через API, используем упрощенный метод
          print('Не удалось получить адрес через API: $e');
          region = _getRegionByCoordinates(position.latitude, position.longitude);
        }
      } else {
        // Если нет клиента, используем упрощенный метод
        region = _getRegionByCoordinates(position.latitude, position.longitude);
      }

      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        city: city,
        region: region,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Запрос 7: Обратное геокодирование (адрес -> координаты)
  Future<Location> getLocationByAddress(String address) async {
    if (_geocodeApi == null) {
      throw Exception('GeocodeApi не настроен');
    }
    try {
      // Используем Retrofit API для обратного геокодирования
      final response = await _geocodeApi!.reverseGeocode(
        address,
        'json',
        1,
        _geocodeApiKey,
      );

      final responseData = response;
      final features = responseData['response']?['GeoObjectCollection']?['featureMember'] as List?;
      if (features == null || features.isEmpty) {
        throw Exception('Адрес не найден');
      }

      final geoObject = features[0]['GeoObject'];
      final pos = geoObject['Point']?['pos'] as String?;
      if (pos == null) {
        throw Exception('Координаты не найдены');
      }

      final coords = pos.split(' ');
      final longitude = double.parse(coords[0]);
      final latitude = double.parse(coords[1]);

      final metaData = geoObject['metaDataProperty']?['GeocoderMetaData'];
      final fullAddress = metaData?['text'] as String?;
      
      String? city;
      String? region;
      final components = metaData?['Address']?['Components'] as List?;
      if (components != null) {
        for (var component in components) {
          final kind = component['kind'] as String?;
          if (kind == 'locality') {
            city = component['name'] as String?;
          } else if (kind == 'province') {
            region = component['name'] as String?;
          }
        }
      }

      return Location(
        latitude: latitude,
        longitude: longitude,
        address: fullAddress,
        city: city,
        region: region,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Запрос 8: Получение координат города
  Future<Location> getLocationByCity(String city) async {
    // Используем Geocoding API для получения координат города
    return await getLocationByAddress(city);
  }

  // Вспомогательный метод для определения региона по координатам
  String? _getRegionByCoordinates(double lat, double lon) {
    // Упрощенное определение региона по координатам для основных городов России
    if (lat >= 55.5 && lat <= 56.0 && lon >= 37.0 && lon <= 38.0) {
      return 'Москва';
    } else if (lat >= 59.8 && lat <= 60.0 && lon >= 30.0 && lon <= 30.5) {
      return 'Санкт-Петербург';
    } else if (lat >= 54.9 && lat <= 55.1 && lon >= 82.8 && lon <= 83.2) {
      return 'Новосибирск';
    } else if (lat >= 56.7 && lat <= 56.9 && lon >= 60.4 && lon <= 60.8) {
      return 'Екатеринбург';
    } else if (lat >= 55.7 && lat <= 55.9 && lon >= 49.0 && lon <= 49.3) {
      return 'Казань';
    } else if (lat >= 56.2 && lat <= 56.4 && lon >= 43.9 && lon <= 44.1) {
      return 'Нижний Новгород';
    } else if (lat >= 55.1 && lat <= 55.2 && lon >= 61.3 && lon <= 61.5) {
      return 'Челябинск';
    } else if (lat >= 53.1 && lat <= 53.3 && lon >= 50.0 && lon <= 50.3) {
      return 'Самара';
    } else if (lat >= 54.9 && lat <= 55.0 && lon >= 73.2 && lon <= 73.4) {
      return 'Омск';
    }
    // Если не определен, возвращаем null
    return null;
  }

}

