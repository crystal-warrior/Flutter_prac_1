import '../../core/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_auth_data_source.dart';
import '../datasources/local/shared_preferences_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalAuthDataSource _dataSource;
  final SharedPreferencesDataSource _sharedPrefs;
  User? _currentUser;

  AuthRepositoryImpl(
    this._dataSource,
    this._sharedPrefs,
  ) {
    _loadSavedUser();
  }


  Future<void> _loadSavedUser() async {
    // Автологин через токены
    final isLoggedIn = await _sharedPrefs.isLoggedIn();
    if (isLoggedIn) {
      // Пытаемся аутентифицировать по токену
      final user = await _dataSource.authenticateByToken();
      if (user != null) {
        _currentUser = user;
        print('✅ Пользователь восстановлен по токену: ${user.login}');
      }
    }
  }

  @override
  Future<User?> authenticate(String login, String password) async {
    final user = await _dataSource.authenticate(login, password);
    if (user != null) {
      _currentUser = user;
      // Сохраняем состояние входа в SharedPreferences
      // Токены уже сохранены в LocalAuthDataSource.authenticate()
      await _sharedPrefs.saveLoginState(login);
    }
    return user;
  }

  @override
  Future<void> register(User user) async {
    // Сохраняем данные пользователя (БЕЗ пароля) в SharedPreferences
    // Токены уже сохранены в LocalAuthDataSource.register()
    await _dataSource.register(user);
    
    _currentUser = user;
    // Сохраняем состояние входа
    await _sharedPrefs.saveLoginState(user.login);
    
    print('✅ Пользователь ${user.login} успешно зарегистрирован');
  }

  @override
  Future<void> updateUser(User user) async {
    // Сохраняем обновленные данные пользователя (БЕЗ пароля) в SharedPreferences
    await _sharedPrefs.saveUserData(
      user.login,
      user.phone,
      user.email,
      user.region,
      user.city,
      user.address,
    );
    
    // Обновляем текущего пользователя в памяти
    _currentUser = user;
    
    print('✅ Данные пользователя ${user.login} успешно обновлены');
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    
    // Очищаем состояние входа
    await _sharedPrefs.clearLoginState();
    
    // Очищаем токены через LocalAuthDataSource
    await _dataSource.logout();
    
    print('✅ Пользователь вышел из системы.');
  }

  @override
  Future<User?> getCurrentUser() async {
    // Проверяем сохраненное состояние
    final isLoggedIn = await _sharedPrefs.isLoggedIn();
    if (isLoggedIn && _currentUser == null) {
      // Пытаемся получить пользователя через токен
      final user = await _dataSource.getCurrentUser();
      if (user != null) {
        _currentUser = user;
      }
    }
    return _currentUser ?? await _dataSource.getCurrentUser();
  }
}

