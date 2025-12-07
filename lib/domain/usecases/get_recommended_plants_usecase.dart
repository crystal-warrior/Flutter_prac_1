import '../../core/models/recommended_plant.dart';
import '../repositories/recommended_plants_repository.dart';

class GetRecommendedPlantsUseCase {
  final RecommendedPlantsRepository repository;

  GetRecommendedPlantsUseCase(this.repository);

  Future<List<RecommendedPlant>> call({String? region}) {
    if (region != null) {
      return repository.getRecommendedPlantsByRegion(region);
    }
    return repository.getRecommendedPlants();
  }

  Future<List<RecommendedPlant>> searchPlants(String query, {String? region}) {
    return repository.searchPlants(query, region: region);
  }

  Future<RecommendedPlant?> getPlantById(int plantId, {String? region}) {
    return repository.getPlantById(plantId, region: region);
  }
}

