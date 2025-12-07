import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/lunar_calendar.dart';
import '../../../../domain/usecases/get_lunar_calendar_usecase.dart';
import '../../../../domain/usecases/get_location_usecase.dart';
import '../../../../di/service_locator.dart';

class LunarCalendarState {
  final LunarCalendar? calendar;
  final bool isLoading;
  final String? error;

  const LunarCalendarState({
    this.calendar,
    this.isLoading = false,
    this.error,
  });

  LunarCalendarState copyWith({
    LunarCalendar? calendar,
    bool? isLoading,
    String? error,
  }) {
    return LunarCalendarState(
      calendar: calendar ?? this.calendar,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LunarCalendarCubit extends Cubit<LunarCalendarState> {
  final GetLunarCalendarUseCase _getLunarCalendarUseCase;
  final GetLocationUseCase _getLocationUseCase;

  LunarCalendarCubit({
    GetLunarCalendarUseCase? getLunarCalendarUseCase,
    GetLocationUseCase? getLocationUseCase,
  })  : _getLunarCalendarUseCase = getLunarCalendarUseCase ?? locator<GetLunarCalendarUseCase>(),
        _getLocationUseCase = getLocationUseCase ?? locator<GetLocationUseCase>(),
        super(const LunarCalendarState());

  Future<void> loadLunarCalendar(DateTime date) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      double? lat;
      double? lon;
      
      // Получаем координаты для использования данных погоды
      try {
        final location = await _getLocationUseCase.call();
        lat = location.latitude;
        lon = location.longitude;
      } catch (e) {
        // Если не удалось получить координаты, продолжаем без них
        print('Не удалось получить координаты: $e');
      }
      
      final calendar = await _getLunarCalendarUseCase(date, lat: lat, lon: lon);
      emit(state.copyWith(calendar: calendar, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

