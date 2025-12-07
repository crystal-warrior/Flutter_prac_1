import '../../core/models/recommended_plant.dart';
import '../../domain/repositories/recommended_plants_repository.dart';
import '../datasources/local/local_recommended_plants_data_source.dart';
import '../datasources/local/mappers/recommended_plant_mapper.dart';

class RecommendedPlantsRepositoryImpl implements RecommendedPlantsRepository {
  final LocalRecommendedPlantsDataSource _localDataSource;

  RecommendedPlantsRepositoryImpl(this._localDataSource);

  @override
  Future<List<RecommendedPlant>> getRecommendedPlants() async {
    final dtos = await _localDataSource.getRecommendedPlants();
    return dtos.map((dto) => dto.toDomain()).whereType<RecommendedPlant>().toList();
  }

  @override
  Future<List<RecommendedPlant>> getRecommendedPlantsByRegion(String region) async {
    final dtos = await _localDataSource.getRecommendedPlantsByRegion(region);
    return dtos.map((dto) => dto.toDomain()).whereType<RecommendedPlant>().toList();
  }

  @override
  Future<List<RecommendedPlant>> searchPlants(String query, {String? region}) async {
    // Если указан регион, сначала получаем растения этого региона
    final localResults = region != null
        ? await _localDataSource.getRecommendedPlantsByRegion(region)
        : await _localDataSource.getRecommendedPlants();
    
    final queryLower = query.toLowerCase();
    
    return localResults
        .where((plant) {
          // Поиск по названию
          final nameMatch = plant.name.toLowerCase().contains(queryLower);
          // Поиск по типу (дерево, кустарник, растение)
          final typeMatch = plant.type.toLowerCase().contains(queryLower);
          // Поиск по описанию
          final descriptionMatch = plant.description.toLowerCase().contains(queryLower);
          
          return nameMatch || typeMatch || descriptionMatch;
        })
        .map((dto) => dto.toDomain())
        .whereType<RecommendedPlant>()
        .toList();
  }

  @override
  Future<RecommendedPlant?> getPlantById(int plantId, {String? region}) async {
    // Реализация через локальную базу данных
    return null;
  }
}
