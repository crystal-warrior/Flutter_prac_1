import '../../../core/models/lunar_calendar.dart';
import '../../../core/network/dio_client.dart';
import 'weather_data_source.dart';

class LunarCalendarDataSource {
  final DioClient? _weatherClient;

  LunarCalendarDataSource([this._weatherClient]);

  // Запрос 9: Лунный календарь с использованием данных погоды
  Future<LunarCalendar> getLunarCalendarForDate(DateTime date, {double? lat, double? lon}) async {
    // Простой расчет лунного дня (примерно)
    final daysSinceNewMoon = _calculateDaysSinceNewMoon(date);
    final lunarDay = (daysSinceNewMoon % 29.5).round();
    
    String lunarPhase;
    String recommendation;
    bool isGoodForPlanting = true;
    String weatherInfo = '';

    // Если есть координаты и клиент погоды, получаем данные о погоде
    if (lat != null && lon != null && _weatherClient != null) {
      try {
        final weatherDataSource = WeatherDataSource(_weatherClient);
        final weatherDto = await weatherDataSource.getWeatherForDate(lat, lon, date);
        final fact = weatherDto.fact;
        final temp = fact['temp'] as num?;
        final condition = fact['condition'] as String?;
        
        if (temp != null && condition != null) {
          // Переводим условие погоды на русский
          final conditionRu = _translateWeatherCondition(condition);
          weatherInfo = 'Температура: ${temp.round()}°C, $conditionRu. ';
          
          // Учитываем погоду при рекомендациях
          if (temp < 0) {
            weatherInfo += ' Внимание: возможны заморозки!';
            isGoodForPlanting = false;
          } else if (temp > 30) {
            weatherInfo += ' Внимание: жаркая погода, требуется дополнительный полив.';
          }
        }
      } catch (e) {
        // Если не удалось получить погоду, продолжаем без неё
        print('Не удалось получить данные о погоде: $e');
      }
    }

    if (lunarDay <= 7) {
      lunarPhase = 'Растущая луна';
      recommendation = weatherInfo + 'Благоприятное время для посадки растений, которые растут вверх';
    } else if (lunarDay <= 14) {
      lunarPhase = 'Растущая луна';
      recommendation = weatherInfo + 'Хорошее время для посадки и пересадки';
    } else if (lunarDay <= 22) {
      lunarPhase = 'Убывающая луна';
      recommendation = weatherInfo + 'Подходит для посадки корнеплодов и обрезки';
    } else {
      lunarPhase = 'Новолуние/Полнолуние';
      recommendation = weatherInfo + 'Не рекомендуется сажать растения';
      isGoodForPlanting = false;
    }

    return LunarCalendar(
      date: date,
      lunarDay: 'День $lunarDay',
      lunarPhase: lunarPhase,
      recommendation: recommendation,
      isGoodForPlanting: isGoodForPlanting,
    );
  }

  int _calculateDaysSinceNewMoon(DateTime date) {
    // Упрощенный расчет - в реальном приложении нужен точный алгоритм
    // или использование библиотеки для расчета лунных фаз
    final epoch = DateTime(2000, 1, 6); // Известное новолуние
    final difference = date.difference(epoch).inDays;
    return difference % 29;
  }

  // Перевод условий погоды с английского на русский
  String _translateWeatherCondition(String condition) {
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

