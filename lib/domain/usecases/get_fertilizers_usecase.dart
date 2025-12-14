import '../../core/models/fertilizer.dart';
import '../repositories/fertilizers_repository.dart';

class GetFertilizersUseCase {
  final FertilizersRepository repository;

  GetFertilizersUseCase(this.repository);

  Future<List<Fertilizer>> call() {
    return repository.getFertilizers();
  }
}












