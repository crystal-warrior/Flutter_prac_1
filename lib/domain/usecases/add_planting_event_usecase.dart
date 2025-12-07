import '../../core/models/planting_event.dart';
import '../repositories/planting_calendar_repository.dart';

class AddPlantingEventUseCase {
  final PlantingCalendarRepository repository;

  AddPlantingEventUseCase(this.repository);

  Future<void> call(PlantingEvent event, String userLogin) {
    return repository.addEvent(event, userLogin);
  }
}


