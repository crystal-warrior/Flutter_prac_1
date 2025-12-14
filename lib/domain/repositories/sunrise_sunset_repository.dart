import '../models/sunrise_sunset.dart';

abstract class SunriseSunsetRepository {
  Future<SunriseSunset> getSunriseSunset({
    required double latitude,
    required double longitude,
    String? date,
  });
}












