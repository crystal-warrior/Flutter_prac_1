import '../../core/models/plant.dart';
import '../repositories/plants_repository.dart';

class GetAllPlantsUseCase {
  final PlantsRepository repository;

  GetAllPlantsUseCase(this.repository);

  Future<List<Plant>> call() {
    return repository.getAllPlants();
  }
}










