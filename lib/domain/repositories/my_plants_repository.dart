import '../../core/models/my_plant.dart';

abstract class MyPlantsRepository {
  Future<List<MyPlant>> getMyPlants();
  Future<void> addMyPlant(MyPlant plant);
  Future<void> removeMyPlant(int index);
}











