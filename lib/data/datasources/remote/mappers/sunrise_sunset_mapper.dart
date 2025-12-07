import '../../../../domain/models/sunrise_sunset.dart';
import '../dto/sunrise_sunset_dto.dart';

extension SunriseSunsetMapper on SunriseSunsetDto {
  SunriseSunset toDomain() {
    final results = this.results ?? {};
    
    // Преобразуем время в ISO формат (для совместимости с существующим кодом)
    String toIsoTime(dynamic time) {
      if (time == null) return '';
      final timeStr = time.toString();
      if (timeStr.isEmpty) return '';
      // Если уже в ISO формате, возвращаем как есть
      if (timeStr.contains('T')) return timeStr;
      // Если в формате "HH:MM" или "HH:MM:SS", преобразуем в ISO
      try {
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          final hour = parts[0].padLeft(2, '0');
          final minute = parts[1].padLeft(2, '0');
          final second = parts.length > 2 ? parts[2].split(' ')[0].padLeft(2, '0') : '00';
          return 'T$hour:$minute:$second';
        }
      } catch (e) {
        // Если не удалось распарсить, возвращаем как есть
      }
      return timeStr;
    }
    
    // Вычисляем продолжительность дня в секундах
    int calculateDayLength(String sunrise, String sunset) {
      try {
        final sunriseParts = sunrise.replaceAll('T', '').split(':');
        final sunsetParts = sunset.replaceAll('T', '').split(':');
        
        if (sunriseParts.length >= 2 && sunsetParts.length >= 2) {
          final sunriseHour = int.parse(sunriseParts[0]);
          final sunriseMin = int.parse(sunriseParts[1]);
          final sunsetHour = int.parse(sunsetParts[0]);
          final sunsetMin = int.parse(sunsetParts[1]);
          
          final sunriseMinutes = sunriseHour * 60 + sunriseMin;
          final sunsetMinutes = sunsetHour * 60 + sunsetMin;
          final dayLengthMinutes = sunsetMinutes - sunriseMinutes;
          return dayLengthMinutes * 60;
        }
      } catch (e) {
        print('Ошибка вычисления продолжительности дня: $e');
      }
      return 0;
    }
    
    // HTMLWeb API может возвращать данные в разных полях
    final sunrise = toIsoTime(results['sunrise'] ?? 
                              results['sunrise_time'] ?? 
                              results['sunrise_utc'] ??
                              results['sunrise_local']);
    final sunset = toIsoTime(results['sunset'] ?? 
                            results['sunset_time'] ?? 
                            results['sunset_utc'] ??
                            results['sunset_local']);
    final dayLength = results['day_length'] as int? ?? 
                     (sunrise.isNotEmpty && sunset.isNotEmpty ? calculateDayLength(sunrise, sunset) : 0);
    
    // Вычисляем солнечный полдень
    String calculateSolarNoon(String sunrise, String sunset) {
      try {
        final sunriseParts = sunrise.replaceAll('T', '').split(':');
        final sunsetParts = sunset.replaceAll('T', '').split(':');
        
        if (sunriseParts.length >= 2 && sunsetParts.length >= 2) {
          final sunriseHour = int.parse(sunriseParts[0]);
          final sunriseMin = int.parse(sunriseParts[1]);
          final sunsetHour = int.parse(sunsetParts[0]);
          final sunsetMin = int.parse(sunsetParts[1]);
          
          final sunriseMinutes = sunriseHour * 60 + sunriseMin;
          final sunsetMinutes = sunsetHour * 60 + sunsetMin;
          final noonMinutes = (sunriseMinutes + sunsetMinutes) ~/ 2;
          final noonHour = noonMinutes ~/ 60;
          final noonMin = noonMinutes % 60;
          return 'T${noonHour.toString().padLeft(2, '0')}:${noonMin.toString().padLeft(2, '0')}:00';
        }
      } catch (e) {
        print('Ошибка вычисления солнечного полдня: $e');
      }
      return '';
    }
    
    final solarNoon = results['solar_noon'] != null 
        ? toIsoTime(results['solar_noon'])
        : (sunrise.isNotEmpty && sunset.isNotEmpty ? calculateSolarNoon(sunrise, sunset) : '');
    
    return SunriseSunset(
      sunrise: sunrise,
      sunset: sunset,
      solarNoon: solarNoon,
      dayLength: dayLength,
      civilTwilightBegin: toIsoTime(results['civil_twilight_begin'] ?? results['dawn'] ?? sunrise),
      civilTwilightEnd: toIsoTime(results['civil_twilight_end'] ?? results['dusk'] ?? sunset),
      nauticalTwilightBegin: toIsoTime(results['nautical_twilight_begin'] ?? sunrise),
      nauticalTwilightEnd: toIsoTime(results['nautical_twilight_end'] ?? sunset),
      astronomicalTwilightBegin: toIsoTime(results['astronomical_twilight_begin'] ?? sunrise),
      astronomicalTwilightEnd: toIsoTime(results['astronomical_twilight_end'] ?? sunset),
    );
  }
}

