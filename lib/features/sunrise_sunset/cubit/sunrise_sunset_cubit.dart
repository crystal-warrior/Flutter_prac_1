import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/models/sunrise_sunset.dart';
import '../../../../domain/usecases/get_sunrise_sunset_usecase.dart';
import '../../../../di/service_locator.dart';

class SunriseSunsetState {
  final SunriseSunset? data;
  final bool isLoading;
  final String? error;

  const SunriseSunsetState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  SunriseSunsetState copyWith({
    SunriseSunset? data,
    bool? isLoading,
    String? error,
  }) {
    return SunriseSunsetState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SunriseSunsetCubit extends Cubit<SunriseSunsetState> {
  final GetSunriseSunsetUseCase _getSunriseSunsetUseCase;

  SunriseSunsetCubit({
    GetSunriseSunsetUseCase? getSunriseSunsetUseCase,
  })  : _getSunriseSunsetUseCase = getSunriseSunsetUseCase ?? locator<GetSunriseSunsetUseCase>(),
        super(const SunriseSunsetState()) {
    loadSunriseSunset();
  }

  Future<void> loadSunriseSunset({String? date}) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {

      // Не используем IP локацию, так как координаты зафиксированы в DataSource
      final data = await _getSunriseSunsetUseCase(
        latitude: 55.7558, // Москва
        longitude: 37.6173, // Москва
        date: date,
      );
      emit(state.copyWith(data: data, isLoading: false, error: null));
    } catch (e) {
      print('Ошибка загрузки времени восхода/заката: $e');
      final errorMessage = e.toString();
      // Проверяем на CORS ошибку
      if (errorMessage.contains('CORS') || errorMessage.contains('XMLHttpRequest')) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Sunrise-Sunset API недоступен в веб-версии из-за ограничений CORS.\n\nИспользуйте мобильное приложение (Android/iOS) для просмотра времени восхода и заката.',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Не удалось загрузить данные: ${e.toString()}',
        ));
      }
    }
  }
}

