import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/weather.dart';
import '../../../../domain/usecases/get_weather_usecase.dart';
import '../../../../domain/usecases/get_location_usecase.dart';
import '../../../../di/service_locator.dart';

class WeatherState {
  final Weather? weather;
  final bool isLoading;
  final String? error;

  const WeatherState({
    this.weather,
    this.isLoading = false,
    this.error,
  });

  WeatherState copyWith({
    Weather? weather,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherUseCase _getWeatherUseCase;
  final GetLocationUseCase _getLocationUseCase;

  WeatherCubit({
    GetWeatherUseCase? getWeatherUseCase,
    GetLocationUseCase? getLocationUseCase,
  })  : _getWeatherUseCase = getWeatherUseCase ?? locator<GetWeatherUseCase>(),
        _getLocationUseCase = getLocationUseCase ?? locator<GetLocationUseCase>(),
        super(const WeatherState());

  Future<void> loadWeather() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final location = await _getLocationUseCase();
      // Передаем название города из Location в Weather
      final cityName = location.city ?? location.region;
      final weather = await _getWeatherUseCase(
        location.latitude,
        location.longitude,
        cityName: cityName,
      );
      emit(state.copyWith(weather: weather, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadWeatherByCity(String city) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final weather = await _getWeatherUseCase.callByCity(city);
      emit(state.copyWith(weather: weather, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

