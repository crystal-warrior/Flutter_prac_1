import '../../core/models/lunar_calendar.dart';
import '../repositories/lunar_calendar_repository.dart';

class GetLunarCalendarUseCase {
  final LunarCalendarRepository repository;

  GetLunarCalendarUseCase(this.repository);

  Future<LunarCalendar> call(DateTime date, {double? lat, double? lon}) {
    return repository.getLunarCalendarForDate(date, lat: lat, lon: lon);
  }
}

