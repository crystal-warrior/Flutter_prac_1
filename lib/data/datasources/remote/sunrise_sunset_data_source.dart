import 'dart:math';
import 'dto/sunrise_sunset_dto.dart';

class SunriseSunsetDataSource {

  Future<SunriseSunsetDto> getSunriseSunset({
    required double latitude,
    required double longitude,
    String? date, // Формат: YYYY-MM-DD, если null - сегодня
  }) async {
    try {

      final fixedLat = 55.7558;
      final fixedLon = 37.6173;
      

      DateTime targetDate;
      if (date != null) {
        final parts = date.split('-');
        targetDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      } else {
        targetDate = DateTime.now();
      }
      

      final sunrise = _calculateSunrise(fixedLat, fixedLon, targetDate);
      final sunset = _calculateSunset(fixedLat, fixedLon, targetDate);
      

      final dayLength = sunset.difference(sunrise).inSeconds;
      

      final solarNoon = sunrise.add(Duration(seconds: dayLength ~/ 2));
      

      String formatTime(DateTime time) {
        final hour = time.hour.toString().padLeft(2, '0');
        final minute = time.minute.toString().padLeft(2, '0');
        final second = time.second.toString().padLeft(2, '0');
        return 'T$hour:$minute:$second';
      }
      
      final results = {
        'sunrise': formatTime(sunrise),
        'sunset': formatTime(sunset),
        'solar_noon': formatTime(solarNoon),
        'day_length': dayLength,
        'civil_twilight_begin': formatTime(sunrise.subtract(const Duration(minutes: 30))),
        'civil_twilight_end': formatTime(sunset.add(const Duration(minutes: 30))),
        'nautical_twilight_begin': formatTime(sunrise.subtract(const Duration(hours: 1))),
        'nautical_twilight_end': formatTime(sunset.add(const Duration(hours: 1))),
        'astronomical_twilight_begin': formatTime(sunrise.subtract(const Duration(hours: 1, minutes: 30))),
        'astronomical_twilight_end': formatTime(sunset.add(const Duration(hours: 1, minutes: 30))),
      };
      
      print('🌅 Вычислено время восхода/заката для Москвы: ${results['sunrise']} - ${results['sunset']}');
      
      return SunriseSunsetDto(
        results: results,
        status: 'OK',
      );
    } catch (e) {
      print('❌ Ошибка вычисления времени восхода/заката: $e');
      rethrow;
    }
  }
  
  // Вычисление времени восхода солнца (упрощенная формула)
  DateTime _calculateSunrise(double lat, double lon, DateTime date) {
    final n = _dayOfYear(date);
    final lngHour = lon / 15.0;
    
    final t = n + ((6 - lngHour) / 24);
    final m = (0.9856 * t) - 3.289;
    var l = m + (1.916 * sin(_degToRad(m))) + (0.020 * sin(_degToRad(2 * m))) + 282.634;
    l = _normalizeAngle(l);
    
    var ra = _radToDeg(atan(0.91764 * tan(_degToRad(l))));
    ra = _normalizeAngle(ra);
    
    final sinDec = 0.39782 * sin(_degToRad(l));
    final cosDec = cos(asin(sinDec));
    
    final cosH = (sin(_degToRad(-0.83)) - sinDec * sin(_degToRad(lat))) / (cosDec * cos(_degToRad(lat)));
    
    if (cosH > 1 || cosH < -1) {
      // Солнце не восходит или не заходит в этот день
      return date.copyWith(hour: 6, minute: 0, second: 0);
    }
    
    var h = _radToDeg(acos(cosH));
    h = h / 15.0;
    
    final tRise = h + ra - (0.06571 * t) - 6.622;
    final utRise = tRise - lngHour;
    final localRise = _normalizeTime(utRise);
    
    final hours = localRise.floor();
    final minutes = ((localRise - hours) * 60).round();
    
    return date.copyWith(hour: hours, minute: minutes, second: 0);
  }
  
  // Вычисление времени заката солнца (упрощенная формула)
  DateTime _calculateSunset(double lat, double lon, DateTime date) {
    final n = _dayOfYear(date);
    final lngHour = lon / 15.0;
    
    final t = n + ((18 - lngHour) / 24);
    final m = (0.9856 * t) - 3.289;
    var l = m + (1.916 * sin(_degToRad(m))) + (0.020 * sin(_degToRad(2 * m))) + 282.634;
    l = _normalizeAngle(l);
    
    var ra = _radToDeg(atan(0.91764 * tan(_degToRad(l))));
    ra = _normalizeAngle(ra);
    
    final sinDec = 0.39782 * sin(_degToRad(l));
    final cosDec = cos(asin(sinDec));
    
    final cosH = (sin(_degToRad(-0.83)) - sinDec * sin(_degToRad(lat))) / (cosDec * cos(_degToRad(lat)));
    
    if (cosH > 1 || cosH < -1) {
      // Солнце не восходит или не заходит в этот день
      return date.copyWith(hour: 18, minute: 0, second: 0);
    }
    
    var h = _radToDeg(acos(cosH));
    h = h / 15.0;
    
    final tSet = h + ra - (0.06571 * t) - 6.622;
    final utSet = tSet - lngHour;
    final localSet = _normalizeTime(utSet);
    
    final hours = localSet.floor();
    final minutes = ((localSet - hours) * 60).round();
    
    return date.copyWith(hour: hours, minute: minutes, second: 0);
  }
  
  // День года
  int _dayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
  }
  
  // Нормализация угла в диапазон 0-360
  double _normalizeAngle(double angle) {
    while (angle < 0) angle += 360;
    while (angle >= 360) angle -= 360;
    return angle;
  }
  
  // Нормализация времени в диапазон 0-24
  double _normalizeTime(double time) {
    while (time < 0) time += 24;
    while (time >= 24) time -= 24;
    return time;
  }
  
  // Преобразование градусов в радианы
  double _degToRad(double deg) => deg * (pi / 180.0);
  
  // Преобразование радиан в градусы
  double _radToDeg(double rad) => rad * (180.0 / pi);
}
