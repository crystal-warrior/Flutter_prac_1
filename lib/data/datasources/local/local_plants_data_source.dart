import '../../../../core/models/plant.dart';

class LocalPlantsDataSource {
  List<Plant> _plants = [];

  Future<List<Plant>> getAllPlants() async {
    return List.from(_plants);
  }

  Future<Plant?> getPlantById(String id) async {
    try {
      return _plants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addPlant(Plant plant) async {
    _plants.add(plant);
  }

  Future<void> updatePlant(Plant plant) async {
    final index = _plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      _plants[index] = plant;
    }
  }

  Future<void> deletePlant(String id) async {
    _plants.removeWhere((plant) => plant.id == id);
  }
}





