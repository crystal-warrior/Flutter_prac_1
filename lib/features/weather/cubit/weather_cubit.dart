import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/weather.dart';
import '../../../../domain/usecases/get_weather_usecase.dart';
import '../../../../domain/usecases/get_location_usecase.dart';
import '../../../../di/service_locator.dart';

class WeatherState {
  final Weather? weather;
  final List<Weather>? forecast;
  final List<Weather>? comparison;
  final String? selectedCity;
  final DateTime? selectedDate;
  final bool isLoading;
  final String? error;

  const WeatherState({
    this.weather,
    this.forecast,
    this.comparison,
    this.selectedCity,
    this.selectedDate,
    this.isLoading = false,
    this.error,
  });

  WeatherState copyWith({
    Weather? weather,
    List<Weather>? forecast,
    List<Weather>? comparison,
    String? selectedCity,
    DateTime? selectedDate,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
      comparison: comparison ?? this.comparison,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherUseCase _getWeatherUseCase;
  final GetLocationUseCase _getLocationUseCase;
  double? _currentLat;
  double? _currentLon;
  String? _currentCityName;

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
      _currentLat = location.latitude;
      _currentLon = location.longitude;
      _currentCityName = location.city ?? location.region;
      
      final weather = await _getWeatherUseCase(
        location.latitude,
        location.longitude,
        cityName: _currentCityName,
      );
      emit(state.copyWith(
        weather: weather,
        selectedCity: _currentCityName,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadWeatherByCity(String city) async {
    emit(state.copyWith(isLoading: true, error: null, selectedCity: city));
    try {
      final weather = await _getWeatherUseCase.callByCity(city);
      _currentCityName = city;
      emit(state.copyWith(weather: weather, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadForecast({String? city}) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final lat = _currentLat;
      final lon = _currentLon;
      final cityName = city ?? _currentCityName;
      
      if (lat == null || lon == null) {
        // Для прогноза нужны координаты, поэтому используем текущее местоположение
        final location = await _getLocationUseCase();
        final forecast = await _getWeatherUseCase.getForecast(
          location.latitude,
          location.longitude,
          limit: 7,
          cityName: cityName,
        );
        emit(state.copyWith(forecast: forecast, isLoading: false));
      } else {
        final forecast = await _getWeatherUseCase.getForecast(
          lat,
          lon,
          limit: 7,
          cityName: cityName,
        );
        emit(state.copyWith(forecast: forecast, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadWeatherForDate(DateTime date) async {
    emit(state.copyWith(isLoading: true, error: null, selectedDate: date));
    try {
      final lat = _currentLat;
      final lon = _currentLon;
      
      if (lat == null || lon == null) {
        final location = await _getLocationUseCase();
        _currentLat = location.latitude;
        _currentLon = location.longitude;
        final weather = await _getWeatherUseCase.getForDate(
          location.latitude,
          location.longitude,
          date,
          cityName: _currentCityName,
        );
        if (weather != null) {
          emit(state.copyWith(weather: weather, isLoading: false));
        } else {
          emit(state.copyWith(isLoading: false, error: 'Данные для выбранной даты недоступны'));
        }
      } else {
        final weather = await _getWeatherUseCase.getForDate(
          lat,
          lon,
          date,
          cityName: _currentCityName,
        );
        if (weather != null) {
          emit(state.copyWith(weather: weather, isLoading: false));
        } else {
          emit(state.copyWith(isLoading: false, error: 'Данные для выбранной даты недоступны'));
        }
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> compareWithCity(String city) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Используем город из текущей погоды, если он есть, иначе из сохраненного значения
      final currentCity = state.weather?.city ?? _currentCityName ?? 'Москва';
      
      // Убеждаемся, что города разные
      if (currentCity.toLowerCase().trim() == city.toLowerCase().trim()) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Выберите другой город для сравнения',
        ));
        return;
      }
      
      final comparison = await _getWeatherUseCase.compareCities([currentCity, city]);
      emit(state.copyWith(comparison: comparison, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> compareWithMultipleCities(List<String> cities) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Используем метод 4: getLocationsByCities для получения координат всех городов
      // Затем запрашиваем погоду для каждого города
      final comparison = await _getWeatherUseCase.compareCities(cities);
      emit(state.copyWith(comparison: comparison, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void clearComparison() {
    emit(state.copyWith(comparison: null));
  }
}

