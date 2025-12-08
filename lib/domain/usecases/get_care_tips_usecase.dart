import '../../core/models/care_tip.dart';
import '../repositories/care_tips_repository.dart';

class GetCareTipsUseCase {
  final CareTipsRepository repository;

  GetCareTipsUseCase(this.repository);

  Future<List<CareTip>> call() {
    return repository.getCareTips();
  }
}







