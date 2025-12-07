import '../../core/models/planting_event.dart';

abstract class PlantingCalendarRepository {
  Future<Map<String, List<PlantingEvent>>> getEvents(String userLogin);
  Future<void> addEvent(PlantingEvent event, String userLogin);
  Future<void> removeEvent(String dateKey, int index, String userLogin);
}


