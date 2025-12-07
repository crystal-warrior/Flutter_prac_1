import '../../../../core/models/planting_event.dart';

class LocalPlantingCalendarDataSource {
  Map<String, List<PlantingEvent>> _events = {};

  Future<Map<String, List<PlantingEvent>>> getEvents() async {
    return Map.from(_events);
  }

  Future<void> addEvent(PlantingEvent event) async {
    final key = event.dateKey;
    _events.putIfAbsent(key, () => []).add(event);
  }

  Future<void> removeEvent(String dateKey, int index) async {
    if (_events.containsKey(dateKey) && index >= 0 && index < _events[dateKey]!.length) {
      _events[dateKey]!.removeAt(index);
      if (_events[dateKey]!.isEmpty) {
        _events.remove(dateKey);
      }
    }
  }
}





