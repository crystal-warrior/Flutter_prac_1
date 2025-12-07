import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/my_plant.dart';
import '../../../../domain/usecases/add_my_plant_usecase.dart';
import '../../../../domain/usecases/get_my_plants_usecase.dart';
import '../../../../di/service_locator.dart';

class MyPlantsState {
  final List<MyPlant> plants;
  final bool isLoading;
  final String? error;

  const MyPlantsState({
    required this.plants,
    this.isLoading = false,
    this.error,
  });

  MyPlantsState copyWith({
    List<MyPlant>? plants,
    bool? isLoading,
    String? error,
  }) {
    return MyPlantsState(
      plants: plants ?? this.plants,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class MyPlantsCubit extends Cubit<MyPlantsState> {
  final GetMyPlantsUseCase _getMyPlantsUseCase;
  final AddMyPlantUseCase _addMyPlantUseCase;

  MyPlantsCubit({
    GetMyPlantsUseCase? getMyPlantsUseCase,
    AddMyPlantUseCase? addMyPlantUseCase,
  })  : _getMyPlantsUseCase = getMyPlantsUseCase ?? locator<GetMyPlantsUseCase>(),
        _addMyPlantUseCase = addMyPlantUseCase ?? locator<AddMyPlantUseCase>(),
        super(const MyPlantsState(plants: [])) {
    loadMyPlants();
  }

  Future<void> loadMyPlants() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final plants = await _getMyPlantsUseCase();
      emit(state.copyWith(plants: plants, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addPlant(String name, String daysStr) async {
    final days = int.tryParse(daysStr.trim()) ?? 0;
    if (name.trim().isNotEmpty) {
      try {
        // При добавлении растения устанавливаем дату последнего полива как текущую дату минус указанное количество дней
        final newPlant = MyPlant(name: name.trim(), daysUntilWatering: days);
        await _addMyPlantUseCase(newPlant);
        await loadMyPlants();
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    }
  }

  // Метод для обновления дней до полива (вызывается периодически)
  void updateDaysUntilWatering() {
    // Просто перезагружаем растения, чтобы пересчитать дни
    loadMyPlants();
  }

  Future<void> removePlant(int index) async {
    if (index >= 0 && index < state.plants.length) {
      // TODO: Implement remove use case if needed
      final updated = List<MyPlant>.from(state.plants)..removeAt(index);
      emit(state.copyWith(plants: updated));
    }
  }
}
