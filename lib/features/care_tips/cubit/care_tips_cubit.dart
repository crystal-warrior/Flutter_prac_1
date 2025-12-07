import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/care_tip.dart';
import '../../../../domain/models/ip_location.dart';
import '../../../../domain/usecases/add_care_tip_usecase.dart';
import '../../../../domain/usecases/get_care_tips_usecase.dart';
import '../../../../domain/usecases/get_ip_location_usecase.dart';
import '../../../../di/service_locator.dart';

class CareTipsState {
  final List<CareTip> tips;
  final bool isLoading;
  final String? error;
  final IpLocation? location;
  final bool isLoadingLocation;

  const CareTipsState({
    required this.tips,
    this.isLoading = false,
    this.error,
    this.location,
    this.isLoadingLocation = false,
  });

  CareTipsState copyWith({
    List<CareTip>? tips,
    bool? isLoading,
    String? error,
    IpLocation? location,
    bool? isLoadingLocation,
  }) {
    return CareTipsState(
      tips: tips ?? this.tips,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      location: location ?? this.location,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
    );
  }
}

class CareTipsCubit extends Cubit<CareTipsState> {
  final GetCareTipsUseCase _getCareTipsUseCase;
  final AddCareTipUseCase _addCareTipUseCase;
  final GetIpLocationUseCase _getIpLocationUseCase;

  CareTipsCubit({
    GetCareTipsUseCase? getCareTipsUseCase,
    AddCareTipUseCase? addCareTipUseCase,
    GetIpLocationUseCase? getIpLocationUseCase,
  })  : _getCareTipsUseCase = getCareTipsUseCase ?? locator<GetCareTipsUseCase>(),
        _addCareTipUseCase = addCareTipUseCase ?? locator<AddCareTipUseCase>(),
        _getIpLocationUseCase = getIpLocationUseCase ?? locator<GetIpLocationUseCase>(),
        super(const CareTipsState(tips: [])) {
    loadCareTips();
    loadLocation();
  }

  Future<void> loadCareTips() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final tips = await _getCareTipsUseCase();
      emit(state.copyWith(tips: tips, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addTip(String title, String tip) async {
    if (title.trim().isNotEmpty && tip.trim().isNotEmpty) {
      try {
        final newTip = CareTip(title: title.trim(), tip: tip.trim());
        await _addCareTipUseCase(newTip);
        await loadCareTips();
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    }
  }

  Future<void> removeTip(int index) async {
    if (index >= 0 && index < state.tips.length) {
      // TODO: Implement remove use case if needed
      final updated = List<CareTip>.from(state.tips)..removeAt(index);
      emit(state.copyWith(tips: updated));
    }
  }

  Future<void> loadLocation() async {
    emit(state.copyWith(isLoadingLocation: true));
    try {
      final location = await _getIpLocationUseCase();
      emit(state.copyWith(location: location, isLoadingLocation: false));
    } catch (e) {
      print('Ошибка загрузки локации: $e');
      emit(state.copyWith(isLoadingLocation: false));
    }
  }
}
