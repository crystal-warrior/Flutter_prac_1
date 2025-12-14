import '../../core/models/fertilizer.dart';
import '../../domain/repositories/fertilizers_repository.dart';
import '../datasources/local/local_fertilizers_data_source.dart';

class FertilizersRepositoryImpl implements FertilizersRepository {
  final LocalFertilizersDataSource _dataSource;

  FertilizersRepositoryImpl(this._dataSource);

  @override
  Future<List<Fertilizer>> getFertilizers() async {
    return await _dataSource.getFertilizers();
  }

  @override
  Future<void> addFertilizer(Fertilizer fertilizer) async {
    await _dataSource.addFertilizer(fertilizer);
  }

  @override
  Future<void> removeFertilizer(int index) async {
    await _dataSource.removeFertilizer(index);
  }
}












