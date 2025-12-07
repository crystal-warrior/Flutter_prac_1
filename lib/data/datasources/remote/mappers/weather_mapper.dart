import '../../../../core/models/weather.dart';
import '../dto/weather_dto.dart';

extension WeatherMapper on WeatherDto {
  Weather toDomain({String? cityName}) {
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
      date: DateTime.now(),
    );
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

