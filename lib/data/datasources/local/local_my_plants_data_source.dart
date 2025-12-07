import '../../../../core/models/my_plant.dart';

class LocalMyPlantsDataSource {
  List<MyPlant> _plants = [
    MyPlant(name: 'Кактус', daysUntilWatering: 7),
    MyPlant(name: 'Фикус', daysUntilWatering: 3),
    MyPlant(name: 'Роза', daysUntilWatering: 1),
  ];

  Future<List<MyPlant>> getMyPlants() async {
    return List.from(_plants);
  }

  Future<void> addMyPlant(MyPlant plant) async {
    _plants.add(plant);
  }

  Future<void> removeMyPlant(int index) async {
    if (index >= 0 && index < _plants.length) {
      _plants.removeAt(index);
    }
  }
}


