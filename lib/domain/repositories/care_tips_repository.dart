import '../../core/models/care_tip.dart';

abstract class CareTipsRepository {
  Future<List<CareTip>> getCareTips();
  Future<void> addCareTip(CareTip tip);
  Future<void> removeCareTip(int index);
}












