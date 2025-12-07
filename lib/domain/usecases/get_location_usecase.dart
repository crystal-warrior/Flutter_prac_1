import '../../core/models/location.dart';
import '../repositories/location_repository.dart';

class GetLocationUseCase {
  final LocationRepository repository;

  GetLocationUseCase(this.repository);

  Future<Location> call() {
    return repository.getCurrentLocation();
  }
}





