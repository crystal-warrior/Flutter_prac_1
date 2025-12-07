import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/planting_event.dart';
import '../../../../domain/usecases/add_planting_event_usecase.dart';
import '../../../../domain/usecases/get_planting_events_usecase.dart';
import '../../../../domain/usecases/authenticate_usecase.dart';
import '../../../../domain/repositories/planting_calendar_repository.dart';
import '../../../../di/service_locator.dart';

class PlantingCalendarState {
  final Map<String, List<PlantingEvent>> events; // ключ — 'YYYY-MM-DD'
  final bool isLoading;
  final String? error;

  const PlantingCalendarState({
    required this.events,
    this.isLoading = false,
    this.error,
  });

  PlantingCalendarState copyWith({
    Map<String, List<PlantingEvent>>? events,
    bool? isLoading,
    String? error,
  }) {
    return PlantingCalendarState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<PlantingEvent>? getEventsForDate(DateTime date) {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return events[key];
  }

  bool hasEventOnDate(DateTime date) {
    return getEventsForDate(date) != null && getEventsForDate(date)!.isNotEmpty;
  }
}

class PlantingCalendarCubit extends Cubit<PlantingCalendarState> {
  final GetPlantingEventsUseCase _getPlantingEventsUseCase;
  final AddPlantingEventUseCase _addPlantingEventUseCase;
  final AuthenticateUseCase _authenticateUseCase;

  PlantingCalendarCubit({
    GetPlantingEventsUseCase? getPlantingEventsUseCase,
    AddPlantingEventUseCase? addPlantingEventUseCase,
    AuthenticateUseCase? authenticateUseCase,
  })  : _getPlantingEventsUseCase = getPlantingEventsUseCase ?? locator<GetPlantingEventsUseCase>(),
        _addPlantingEventUseCase = addPlantingEventUseCase ?? locator<AddPlantingEventUseCase>(),
        _authenticateUseCase = authenticateUseCase ?? locator<AuthenticateUseCase>(),
        super(const PlantingCalendarState(events: {})) {
    loadEvents();
  }

  Future<String?> _getCurrentUserLogin() async {
    final user = await _authenticateUseCase.getCurrentUser();
    return user?.login;
  }

  Future<void> loadEvents() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final userLogin = await _getCurrentUserLogin();
      if (userLogin == null) {
        print('⚠️ Пользователь не авторизован, события не загружены');
        emit(state.copyWith(events: {}, isLoading: false));
        return;
      }
      print('🔄 Загрузка событий для пользователя: $userLogin');
      final events = await _getPlantingEventsUseCase(userLogin);
      print('✅ События загружены: ${events.keys.toList()}');
      emit(state.copyWith(events: events, isLoading: false));
    } catch (e) {
      print('❌ Ошибка при загрузке событий: $e');
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addEvent(DateTime date, String note) async {
    if (note.trim().isEmpty) return;
    try {
      final userLogin = await _getCurrentUserLogin();
      if (userLogin == null) {
        emit(state.copyWith(error: 'Пользователь не авторизован'));
        return;
      }
      
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final existingEvents = state.getEventsForDate(date);
      
      // Если событие уже существует, обновляем его (удаляем старое и добавляем новое)
      if (existingEvents != null && existingEvents.isNotEmpty) {
        print('🔄 Обновление существующего события: dateKey=$dateKey, user=$userLogin');
        // Удаляем старое событие
        final repository = locator<PlantingCalendarRepository>();
        await repository.removeEvent(dateKey, 0, userLogin);
      }
      
      final newEvent = PlantingEvent(date: date, note: note.trim());
      print('➕ ${existingEvents != null && existingEvents.isNotEmpty ? "Обновление" : "Добавление"} события: date=${newEvent.date}, dateKey=${newEvent.dateKey}, note=${newEvent.note}, user=$userLogin');
      await _addPlantingEventUseCase(newEvent, userLogin);
      print('✅ Событие ${existingEvents != null && existingEvents.isNotEmpty ? "обновлено" : "добавлено"}, перезагружаем события...');
      await loadEvents();
      print('✅ События перезагружены, текущее состояние: ${state.events.keys.toList()}');
    } catch (e) {
      print('❌ Ошибка при добавлении события: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> removeEvent(DateTime date, int index) async {
    try {
      final userLogin = await _getCurrentUserLogin();
      if (userLogin == null) {
        emit(state.copyWith(error: 'Пользователь не авторизован'));
        return;
      }
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      // Используем репозиторий для удаления
      final repository = locator<PlantingCalendarRepository>();
      await repository.removeEvent(key, index, userLogin);
      // Перезагружаем события
      await loadEvents();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
