import '../../core/models/my_plant.dart';
import '../repositories/my_plants_repository.dart';

class GetMyPlantsUseCase {
  final MyPlantsRepository repository;

  GetMyPlantsUseCase(this.repository);

  Future<List<MyPlant>> call() {
    return repository.getMyPlants();
  }
}










