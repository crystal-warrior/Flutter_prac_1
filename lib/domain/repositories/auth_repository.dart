import '../../core/models/user.dart';

abstract class AuthRepository {
  Future<User?> authenticate(String login, String password);
  Future<void> register(User user);
  Future<void> updateUser(User user);
  Future<void> logout();
  Future<User?> getCurrentUser();
}






