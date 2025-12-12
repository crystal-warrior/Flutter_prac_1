import '../../../../core/models/planting_event.dart';
import '../dto/planting_event_dto.dart';

extension PlantingEventMapper on PlantingEventDto {

  PlantingEvent toDomain() {
    return PlantingEvent(
      date: DateTime.parse(date),
      note: note,
    );
  }
}

extension PlantingEventToDto on PlantingEvent {

  PlantingEventDto toDto(String userLogin) {
    return PlantingEventDto(
      userLogin: userLogin,
      date: date.toIso8601String(),
      note: note,
    );
  }
}









