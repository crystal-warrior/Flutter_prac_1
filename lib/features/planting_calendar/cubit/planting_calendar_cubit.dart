import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/planting_event.dart';

class PlantingCalendarState {
  final Map<String, PlantingEvent> events; // ключ — 'YYYY-MM-DD'

  const PlantingCalendarState({required this.events});

  PlantingCalendarState copyWith({Map<String, PlantingEvent>? events}) {
    return PlantingCalendarState(events: events ?? this.events);
  }

  PlantingEvent? getEventForDate(DateTime date) {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return events[key];
  }

  bool hasEventOnDate(DateTime date) {
    return getEventForDate(date) != null;
  }
}

class PlantingCalendarCubit extends Cubit<PlantingCalendarState> {
  PlantingCalendarCubit() : super(const PlantingCalendarState(events: {}));

  void addEvent(DateTime date, String note) {
    if (note.trim().isEmpty) return;
    final newEvent = PlantingEvent(date: date, note: note.trim());
    final updated = Map<String, PlantingEvent>.from(state.events);
    updated[newEvent.dateKey] = newEvent;
    emit(state.copyWith(events: updated));
  }

  void removeEvent(DateTime date) {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final updated = Map<String, PlantingEvent>.from(state.events);
    updated.remove(key);
    emit(state.copyWith(events: updated));
  }
}