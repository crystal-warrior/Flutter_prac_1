import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/recommended_plant.dart';
import '../../../../domain/usecases/get_recommended_plants_usecase.dart';
import '../../../../di/service_locator.dart';

class RecommendedPlantsState {
  final List<RecommendedPlant> plants;
  final String? userRegion;
  final bool isLoading;
  final String? error;

  const RecommendedPlantsState({
    required this.plants,
    this.userRegion,
    this.isLoading = false,
    this.error,
  });

  RecommendedPlantsState copyWith({
    List<RecommendedPlant>? plants,
    String? userRegion,
    bool? isLoading,
    String? error,
  }) {
    return RecommendedPlantsState(
      plants: plants ?? this.plants,
      userRegion: userRegion ?? this.userRegion,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class RecommendedPlantsCubit extends Cubit<RecommendedPlantsState> {
  final GetRecommendedPlantsUseCase _getRecommendedPlantsUseCase;

  RecommendedPlantsCubit({
    GetRecommendedPlantsUseCase? getRecommendedPlantsUseCase,
  })  : _getRecommendedPlantsUseCase = getRecommendedPlantsUseCase ?? locator<GetRecommendedPlantsUseCase>(),
        super(const RecommendedPlantsState(plants: []));

  Future<void> loadPlantsForUserRegion(String? userRegion) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final plants = await _getRecommendedPlantsUseCase(region: userRegion);
      emit(state.copyWith(plants: plants, userRegion: userRegion, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> searchPlants(String query) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Поиск учитывает название, тип, описание и регион пользователя
      final plants = await _getRecommendedPlantsUseCase.searchPlants(query, region: state.userRegion);
      emit(state.copyWith(plants: plants, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
