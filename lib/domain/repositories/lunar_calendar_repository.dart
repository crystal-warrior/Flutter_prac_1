import '../../core/models/lunar_calendar.dart';

abstract class LunarCalendarRepository {
  Future<LunarCalendar> getLunarCalendarForDate(DateTime date, {double? lat, double? lon});
}

