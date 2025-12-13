class OpenWeatherDto {
  final Map<String, dynamic>? main;
  final List<dynamic>? weather;
  final String? name;
  final Map<String, dynamic>? coord;

  OpenWeatherDto({
    this.main,
    this.weather,
    this.name,
    this.coord,
  });

  factory OpenWeatherDto.fromJson(Map<String, dynamic> json) {
    return OpenWeatherDto(
      main: json['main'] as Map<String, dynamic>?,
      weather: json['weather'] as List<dynamic>?,
      name: json['name'] as String?,
      coord: json['coord'] as Map<String, dynamic>?,
    );
  }

  // Получение температуры в Цельсиях
  double? get tempC {
    if (main != null) {
      final temp = main!['temp'] as num?;
      if (temp != null) {
        // OpenWeatherMap возвращает температуру в Кельвинах, конвертируем в Цельсии
        return temp.toDouble() - 273.15;
      }
    }
    return null;
  }

  // Получение описания погоды
  String? get weatherDesc {
    if (weather != null && weather!.isNotEmpty) {
      final weatherItem = weather![0] as Map<String, dynamic>?;
      if (weatherItem != null) {
        // Пробуем получить описание на русском, если есть
        final description = weatherItem['description'] as String?;
        return description;
      }
    }
    return null;
  }

  // Получение влажности
  int? get humidity {
    if (main != null) {
      final hum = main!['humidity'];
      if (hum is num) {
        return hum.toInt();
      } else if (hum is String) {
        return int.tryParse(hum);
      }
    }
    return null;
  }

  // Получение названия города
  String get cityName => name ?? 'Неизвестно';
}











