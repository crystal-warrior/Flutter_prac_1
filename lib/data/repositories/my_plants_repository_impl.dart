import '../../core/models/my_plant.dart';
import '../../domain/repositories/my_plants_repository.dart';
import '../datasources/local/local_my_plants_data_source.dart';

class MyPlantsRepositoryImpl implements MyPlantsRepository {
  final LocalMyPlantsDataSource _dataSource;

  MyPlantsRepositoryImpl(this._dataSource);

  @override
  Future<List<MyPlant>> getMyPlants() async {
    return await _dataSource.getMyPlants();
  }

  @override
  Future<void> addMyPlant(MyPlant plant) async {
    await _dataSource.addMyPlant(plant);
  }

  @override
  Future<void> removeMyPlant(int index) async {
    await _dataSource.removeMyPlant(index);
  }
}





