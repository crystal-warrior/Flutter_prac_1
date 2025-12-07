import '../../../../domain/models/openweather_weather.dart';
import '../dto/openweather_dto.dart';

extension OpenWeatherMapper on OpenWeatherDto {
  OpenWeatherWeather toDomain() {
    // Переводим описание погоды на русский
    String translatedDesc = _translateWeatherCondition(weatherDesc ?? 'Неизвестно');
    
    return OpenWeatherWeather(
      temperature: tempC ?? 0.0,
      description: translatedDesc,
      humidity: humidity ?? 0,
      city: cityName,
    );
  }

  String _translateWeatherCondition(String condition) {
    final conditionLower = condition.toLowerCase();
    
    // Основные переводы погодных условий
    if (conditionLower.contains('clear')) return 'Ясно';
    if (conditionLower.contains('sunny')) return 'Солнечно';
    if (conditionLower.contains('cloud')) return 'Облачно';
    if (conditionLower.contains('overcast')) return 'Пасмурно';
    if (conditionLower.contains('rain')) return 'Дождь';
    if (conditionLower.contains('drizzle')) return 'Моросящий дождь';
    if (conditionLower.contains('thunderstorm')) return 'Гроза';
    if (conditionLower.contains('snow')) return 'Снег';
    if (conditionLower.contains('mist') || conditionLower.contains('fog')) return 'Туман';
    if (conditionLower.contains('haze')) return 'Дымка';
    
    // Если не нашли перевод, возвращаем оригинал с заглавной буквы
    return condition.isEmpty ? 'Неизвестно' : condition;
  }
}





