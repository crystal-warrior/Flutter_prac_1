import '../../core/models/planting_event.dart';
import '../../domain/repositories/planting_calendar_repository.dart';
import '../datasources/local/local_planting_calendar_data_source.dart';
import '../datasources/local/sqlite_planting_calendar_data_source.dart';

class PlantingCalendarRepositoryImpl implements PlantingCalendarRepository {
  final LocalPlantingCalendarDataSource _localDataSource;
  final SqlitePlantingCalendarDataSource _sqliteDataSource;

  PlantingCalendarRepositoryImpl(this._localDataSource, this._sqliteDataSource);

  @override
  Future<Map<String, List<PlantingEvent>>> getEvents(String userLogin) async {

    final sqliteEvents = await _sqliteDataSource.getEvents(userLogin);
    print(' Репозиторий: получено событий из SQLite для $userLogin: ${sqliteEvents.length}');
    return sqliteEvents;
  }

  @override
  Future<void> addEvent(PlantingEvent event, String userLogin) async {

    await _localDataSource.addEvent(event);
    await _sqliteDataSource.addEvent(event, userLogin);
  }

  @override
  Future<void> removeEvent(String dateKey, int index, String userLogin) async {
    await _localDataSource.removeEvent(dateKey, index);
    

    await _sqliteDataSource.deleteEventByDateKey(dateKey, index, userLogin);
    

    final eventId = await _sqliteDataSource.getEventId(dateKey, index, userLogin);
    if (eventId != null) {
      await _sqliteDataSource.deleteEvent(eventId);
    }
  }
}

