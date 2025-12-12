import '../../core/models/fertilizer.dart';
import '../repositories/fertilizers_repository.dart';

class AddFertilizerUseCase {
  final FertilizersRepository repository;

  AddFertilizerUseCase(this.repository);

  Future<void> call(Fertilizer fertilizer) {
    return repository.addFertilizer(fertilizer);
  }
}










