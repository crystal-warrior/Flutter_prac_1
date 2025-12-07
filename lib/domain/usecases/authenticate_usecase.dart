import '../../core/models/user.dart';
import '../repositories/auth_repository.dart';

class AuthenticateUseCase {
  final AuthRepository repository;

  AuthenticateUseCase(this.repository);

  Future<User?> call(String login, String password) {
    return repository.authenticate(login, password);
  }

  Future<User?> getCurrentUser() {
    return repository.getCurrentUser();
  }
}

