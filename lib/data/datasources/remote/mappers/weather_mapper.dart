import '../../../../core/models/weather.dart';
import '../dto/weather_dto.dart';

extension WeatherMapper on WeatherDto {
  Weather toDomain({String? cityName, DateTime? date}) {
    final fact = this.fact;

    final city = cityName ?? geoObject?['locality']?['name'] ?? 'Неизвестно';
    

    final condition = fact['condition'] as String? ?? 'Неизвестно';
    final description = _translateCondition(condition);
    
    return Weather(
      temperature: (fact['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (fact['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: fact['humidity'] as int? ?? 0,
      windSpeed: (fact['wind_speed'] as num?)?.toDouble() ?? 0.0,
      description: description,
      icon: fact['icon'] as String? ?? '',
      city: city,
      date: date ?? DateTime.now(),
    );
  }

  List<Weather> toForecastList({String? cityName}) {
    if (forecasts == null || forecasts!.isEmpty) {
      return [];
    }

    final city = cityName ?? geoObject?['locality']?['name'] ?? 'Неизвестно';
    final List<Weather> weatherList = [];

    for (final forecast in forecasts!) {
      try {
        final forecastMap = forecast as Map<String, dynamic>;
        final dateStr = forecastMap['date'] as String?;
        final date = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
        
        final parts = forecastMap['parts'] as Map<String, dynamic>?;
        final day = parts?['day'] as Map<String, dynamic>?;
        
        if (day != null) {
          final condition = day['condition'] as String? ?? 'Неизвестно';
          final description = _translateCondition(condition);
          
          weatherList.add(Weather(
            temperature: (day['temp_avg'] as num?)?.toDouble() ?? 
                        (day['temp'] as num?)?.toDouble() ?? 0.0,
            feelsLike: (day['feels_like'] as num?)?.toDouble() ?? 0.0,
            humidity: day['humidity'] as int? ?? 0,
            windSpeed: (day['wind_speed'] as num?)?.toDouble() ?? 0.0,
            description: description,
            icon: day['icon'] as String? ?? '',
            city: city,
            date: date,
          ));
        }
      } catch (e) {
        // Пропускаем некорректные данные
        continue;
      }
    }

    return weatherList;
  }

  Weather? getWeatherForDate(DateTime targetDate, {String? cityName}) {
    if (forecasts == null || forecasts!.isEmpty) {
      return null;
    }

    final city = cityName ?? geoObject?['locality']?['name'] ?? 'Неизвестно';

    for (final forecast in forecasts!) {
      try {
        final forecastMap = forecast as Map<String, dynamic>;
        final dateStr = forecastMap['date'] as String?;
        if (dateStr == null) continue;
        
        final date = DateTime.parse(dateStr);
        if (date.year == targetDate.year && 
            date.month == targetDate.month && 
            date.day == targetDate.day) {
          
          final parts = forecastMap['parts'] as Map<String, dynamic>?;
          final day = parts?['day'] as Map<String, dynamic>?;
          
          if (day != null) {
            final condition = day['condition'] as String? ?? 'Неизвестно';
            final description = _translateCondition(condition);
            
            return Weather(
              temperature: (day['temp_avg'] as num?)?.toDouble() ?? 
                          (day['temp'] as num?)?.toDouble() ?? 0.0,
              feelsLike: (day['feels_like'] as num?)?.toDouble() ?? 0.0,
              humidity: day['humidity'] as int? ?? 0,
              windSpeed: (day['wind_speed'] as num?)?.toDouble() ?? 0.0,
              description: description,
              icon: day['icon'] as String? ?? '',
              city: city,
              date: date,
            );
          }
        }
      } catch (e) {
        continue;
      }
    }

    return null;
  }
  

  String _translateCondition(String condition) {
    const translations = {
      'clear': 'Ясно',
      'partly-cloudy': 'Малооблачно',
      'cloudy': 'Облачно',
      'overcast': 'Пасмурно',
      'drizzle': 'Моросящий дождь',
      'light-rain': 'Небольшой дождь',
      'rain': 'Дождь',
      'moderate-rain': 'Умеренный дождь',
      'heavy-rain': 'Сильный дождь',
      'continuous-heavy-rain': 'Длительный сильный дождь',
      'showers': 'Ливень',
      'wet-snow': 'Мокрый снег',
      'light-snow': 'Небольшой снег',
      'snow': 'Снег',
      'snow-showers': 'Снегопад',
      'hail': 'Град',
      'thunderstorm': 'Гроза',
      'thunderstorm-with-rain': 'Гроза с дождем',
      'thunderstorm-with-hail': 'Гроза с градом',
    };
    
    return translations[condition] ?? condition;
  }
}

