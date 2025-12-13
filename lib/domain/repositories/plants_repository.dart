import '../../core/models/plant.dart';

abstract class PlantsRepository {
  Future<List<Plant>> getAllPlants();
  Future<Plant?> getPlantById(String id);
  Future<void> addPlant(Plant plant);
  Future<void> updatePlant(Plant plant);
  Future<void> deletePlant(String id);
}











