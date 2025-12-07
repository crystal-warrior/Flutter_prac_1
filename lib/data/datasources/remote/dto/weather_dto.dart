class WeatherDto {
  final Map<String, dynamic> fact;
  final Map<String, dynamic>? geoObject;
  final List<dynamic>? forecasts;

  WeatherDto({
    required this.fact,
    this.geoObject,
    this.forecasts,
  });

  factory WeatherDto.fromJson(Map<String, dynamic> json) {
    return WeatherDto(
      fact: json['fact'] ?? {},
      geoObject: json['geo_object'],
      forecasts: json['forecasts'] as List<dynamic>?,
    );
  }
}

