import '../../core/models/fertilizer.dart';

abstract class FertilizersRepository {
  Future<List<Fertilizer>> getFertilizers();
  Future<void> addFertilizer(Fertilizer fertilizer);
  Future<void> removeFertilizer(int index);
}





