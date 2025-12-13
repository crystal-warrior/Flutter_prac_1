import '../../core/models/care_tip.dart';
import '../repositories/care_tips_repository.dart';

class AddCareTipUseCase {
  final CareTipsRepository repository;

  AddCareTipUseCase(this.repository);

  Future<void> call(CareTip tip) {
    return repository.addCareTip(tip);
  }
}











