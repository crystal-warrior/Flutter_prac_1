import '../../core/models/plant.dart';
import '../../domain/repositories/plants_repository.dart';
import '../datasources/local/local_plants_data_source.dart';

class PlantsRepositoryImpl implements PlantsRepository {
  final LocalPlantsDataSource _localDataSource;

  PlantsRepositoryImpl(this._localDataSource);

  @override
  Future<List<Plant>> getAllPlants() async {
    return await _localDataSource.getAllPlants();
  }

  @override
  Future<Plant?> getPlantById(String id) async {
    return await _localDataSource.getPlantById(id);
  }

  @override
  Future<void> addPlant(Plant plant) async {
    await _localDataSource.addPlant(plant);
  }

  @override
  Future<void> updatePlant(Plant plant) async {
    await _localDataSource.updatePlant(plant);
  }

  @override
  Future<void> deletePlant(String id) async {
    await _localDataSource.deletePlant(id);
  }
}

