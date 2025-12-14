class SunriseSunset {
  final String sunrise;
  final String sunset;
  final String solarNoon;
  final int dayLength; // в секундах
  final String civilTwilightBegin;
  final String civilTwilightEnd;
  final String nauticalTwilightBegin;
  final String nauticalTwilightEnd;
  final String astronomicalTwilightBegin;
  final String astronomicalTwilightEnd;

  SunriseSunset({
    required this.sunrise,
    required this.sunset,
    required this.solarNoon,
    required this.dayLength,
    required this.civilTwilightBegin,
    required this.civilTwilightEnd,
    required this.nauticalTwilightBegin,
    required this.nauticalTwilightEnd,
    required this.astronomicalTwilightBegin,
    required this.astronomicalTwilightEnd,
  });

  // Форматирование времени дня в секундах в читаемый формат
  String get dayLengthFormatted {
    final hours = dayLength ~/ 3600;
    final minutes = (dayLength % 3600) ~/ 60;
    return '${hours}ч ${minutes}м';
  }

  // Форматирование времени из ISO формата
  String formatTime(String timeString) {
    try {
      final parts = timeString.split('T');
      if (parts.length > 1) {
        final timePart = parts[1].split('+')[0].split('-')[0];
        return timePart.substring(0, 5); // HH:MM
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }
}












