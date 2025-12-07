import '../../core/models/care_tip.dart';
import '../../domain/repositories/care_tips_repository.dart';
import '../datasources/local/local_care_tips_data_source.dart';
import '../datasources/local/mappers/care_tip_mapper.dart';

class CareTipsRepositoryImpl implements CareTipsRepository {
  final LocalCareTipsDataSource _dataSource;

  CareTipsRepositoryImpl(this._dataSource);

  @override
  Future<List<CareTip>> getCareTips() async {
    final dtos = await _dataSource.getCareTips();
    return dtos.map((dto) => dto.toDomain()).whereType<CareTip>().toList();
  }

  @override
  Future<void> addCareTip(CareTip tip) async {
    await _dataSource.addCareTip(tip.toDto());
  }

  @override
  Future<void> removeCareTip(int index) async {
    await _dataSource.removeCareTip(index);
  }
}

