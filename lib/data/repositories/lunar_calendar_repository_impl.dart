import '../../core/models/lunar_calendar.dart';
import '../../domain/repositories/lunar_calendar_repository.dart';
import '../datasources/remote/lunar_calendar_data_source.dart';

class LunarCalendarRepositoryImpl implements LunarCalendarRepository {
  final LunarCalendarDataSource _dataSource;

  LunarCalendarRepositoryImpl(this._dataSource);

  @override
  Future<LunarCalendar> getLunarCalendarForDate(DateTime date, {double? lat, double? lon}) async {
    return await _dataSource.getLunarCalendarForDate(date, lat: lat, lon: lon);
  }
}

