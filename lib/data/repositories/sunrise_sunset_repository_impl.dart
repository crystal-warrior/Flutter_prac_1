import '../../domain/models/sunrise_sunset.dart';
import '../../domain/repositories/sunrise_sunset_repository.dart';
import '../datasources/remote/sunrise_sunset_data_source.dart';
import '../datasources/remote/mappers/sunrise_sunset_mapper.dart';

class SunriseSunsetRepositoryImpl implements SunriseSunsetRepository {
  final SunriseSunsetDataSource _dataSource;

  SunriseSunsetRepositoryImpl(this._dataSource);

  @override
  Future<SunriseSunset> getSunriseSunset({
    required double latitude,
    required double longitude,
    String? date,
  }) async {
    final dto = await _dataSource.getSunriseSunset(
      latitude: latitude,
      longitude: longitude,
      date: date,
    );
    return dto.toDomain();
  }
}











