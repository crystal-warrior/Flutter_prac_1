import '../models/sunrise_sunset.dart';
import '../repositories/sunrise_sunset_repository.dart';

class GetSunriseSunsetUseCase {
  final SunriseSunsetRepository repository;

  GetSunriseSunsetUseCase(this.repository);

  Future<SunriseSunset> call({
    required double latitude,
    required double longitude,
    String? date,
  }) {
    return repository.getSunriseSunset(
      latitude: latitude,
      longitude: longitude,
      date: date,
    );
  }
}





