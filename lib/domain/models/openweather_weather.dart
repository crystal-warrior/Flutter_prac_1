class OpenWeatherWeather {
  final double temperature;
  final String description;
  final int humidity;
  final String city;

  OpenWeatherWeather({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.city,
  });

  // Рекомендация по удобрениям на основе погоды
  String get fertilizerRecommendation {
    // Переводим описание на русский для проверки
    final descLower = description.toLowerCase();
    
    if (descLower.contains('дождь') || 
        descLower.contains('rain') ||
        humidity > 80) {
      return 'Не рекомендуется вносить жидкие удобрения во время дождя или высокой влажности.';
    } else if (temperature < 5) {
      return 'При низкой температуре удобрения усваиваются медленнее. Используйте медленно действующие удобрения.';
    } else if (temperature > 30) {
      return 'В жаркую погоду поливайте растения перед внесением удобрений, чтобы избежать ожогов корней.';
    } else {
      return 'Погодные условия благоприятны для внесения удобрений.';
    }
  }
}





