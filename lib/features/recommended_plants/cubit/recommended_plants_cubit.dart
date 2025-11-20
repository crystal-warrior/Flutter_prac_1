import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/recommended_plant.dart';
import '../data/plant_database.dart';

class RecommendedPlantsState {
  final List<RecommendedPlant> plants;
  final String? userRegion;

  const RecommendedPlantsState({required this.plants, this.userRegion});

  RecommendedPlantsState copyWith({List<RecommendedPlant>? plants, String? userRegion}) {
    return RecommendedPlantsState(
      plants: plants ?? this.plants,
      userRegion: userRegion ?? this.userRegion,
    );
  }
}

class RecommendedPlantsCubit extends Cubit<RecommendedPlantsState> {
  RecommendedPlantsCubit() : super(const RecommendedPlantsState(plants: []));

  void loadPlantsForUserRegion(String? userRegion) {
    if (userRegion == null) {
      emit(state.copyWith(plants: [], userRegion: null));
      return;
    }

    final filtered = allPlants
        .where((plant) => plant.region == userRegion)
        .toList();

    emit(state.copyWith(plants: filtered, userRegion: userRegion));
  }
}