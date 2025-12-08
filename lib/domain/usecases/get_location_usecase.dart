import '../../core/models/location.dart';
import '../repositories/location_repository.dart';

class GetLocationUseCase {
  final LocationRepository repository;

  GetLocationUseCase(this.repository);

  Future<Location> call() {
    return repository.getCurrentLocation();
  }

  Future<Location> getByAddress(String address) {
    return repository.getLocationByAddress(address);
  }

  Future<Location> getByCity(String city) {
    return repository.getLocationByCity(city);
  }

  Future<List<Location>> getByCities(List<String> cities) {
    return repository.getLocationsByCities(cities);
  }

  Future<List<Location>> getByCoordinates(List<Map<String, double>> coordinates) {
    return repository.getAddressesByCoordinates(coordinates);
  }
}






