import '../../core/models/plant.dart';
import '../repositories/plants_repository.dart';

class AddPlantUseCase {
  final PlantsRepository repository;

  AddPlantUseCase(this.repository);

  Future<void> call(Plant plant) {
    return repository.addPlant(plant);
  }
}










