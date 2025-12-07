class SunriseSunsetDto {
  final Map<String, dynamic>? results;
  final String? status;

  SunriseSunsetDto({
    this.results,
    this.status,
  });

  factory SunriseSunsetDto.fromJson(Map<String, dynamic> json) {
    // Regius API может возвращать данные напрямую или в поле 'results'
    // Проверяем оба варианта
    Map<String, dynamic>? resultsData;
    if (json.containsKey('results')) {
      resultsData = json['results'] as Map<String, dynamic>?;
    } else {
      // Если данных нет в 'results', используем весь json как results
      // (для Regius API, который может возвращать данные напрямую)
      resultsData = json;
    }
    
    return SunriseSunsetDto(
      results: resultsData,
      status: json['status'] as String? ?? 'OK',
    );
  }
}

