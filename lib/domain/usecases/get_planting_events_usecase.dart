import '../../core/models/planting_event.dart';
import '../repositories/planting_calendar_repository.dart';

class GetPlantingEventsUseCase {
  final PlantingCalendarRepository repository;

  GetPlantingEventsUseCase(this.repository);

  Future<Map<String, List<PlantingEvent>>> call(String userLogin) {
    return repository.getEvents(userLogin);
  }
}


