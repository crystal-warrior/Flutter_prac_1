import '../../core/models/my_plant.dart';
import '../repositories/my_plants_repository.dart';

class AddMyPlantUseCase {
  final MyPlantsRepository repository;

  AddMyPlantUseCase(this.repository);

  Future<void> call(MyPlant plant) {
    return repository.addMyPlant(plant);
  }
}











