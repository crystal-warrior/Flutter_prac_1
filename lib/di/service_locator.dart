import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

class UserService {
  String? _login;
  String? get login => _login;
  void setLogin(String login) => _login = login;
  void clearLogin() => _login = null;
}

void setupLocator() {
  locator.registerSingleton<UserService>(UserService());
}