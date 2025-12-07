import '../../core/models/recommended_plant.dart';

abstract class RecommendedPlantsRepository {
  Future<List<RecommendedPlant>> getRecommendedPlants();
  Future<List<RecommendedPlant>> getRecommendedPlantsByRegion(String region);
  Future<List<RecommendedPlant>> searchPlants(String query, {String? region});
  Future<RecommendedPlant?> getPlantById(int plantId, {String? region});
}

