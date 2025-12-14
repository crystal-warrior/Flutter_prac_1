import '../../core/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_auth_data_source.dart';
import '../datasources/local/shared_preferences_data_source.dart';
import '../datasources/local/secure_storage_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalAuthDataSource _dataSource;
  final SharedPreferencesDataSource _sharedPrefs;
  final SecureStorageDataSource _secureStorage;
  User? _currentUser;

  AuthRepositoryImpl(
    this._dataSource,
    this._sharedPrefs,
    this._secureStorage,
  ) {
    _loadSavedUser();
  }


  Future<void> _loadSavedUser() async {
    // Автологин через токены (если реализовано)
    // Сейчас просто проверяем состояние входа
    final isLoggedIn = await _sharedPrefs.isLoggedIn();
    if (isLoggedIn) {
      final login = await _sharedPrefs.getCurrentLogin();
      if (login != null) {
        // Проверяем наличие токена для автологина
        final authToken = await _secureStorage.getAuthToken();
        if (authToken != null) {
          // Если токен есть, можно восстановить пользователя
          // Сейчас просто загружаем данные пользователя из SharedPreferences
          final userData = await _sharedPrefs.getUserData(login);
          if (userData['phone'] != null || userData['email'] != null) {
            // Восстанавливаем пользователя из сохраненных данных
            final user = User(
              login: login,
              password: '', // Пароль не сохраняется
              phone: userData['phone'],
              email: userData['email'],
              region: userData['region'],
              city: userData['city'],
              address: userData['address'],
            );
            _currentUser = user;
          }
        }
      }
    }
  }

  @override
  Future<User?> authenticate(String login, String password) async {
    final user = await _dataSource.authenticate(login, password);
    if (user != null) {
      _currentUser = user;
      // Сохраняем состояние входа в SharedPreferences
      await _sharedPrefs.saveLoginState(login);
      // Здесь можно сохранить токен авторизации (если используется токен-авторизация)
      // await _secureStorage.saveAuthToken(token);
    }
    return user;
  }

  @override
  Future<void> register(User user) async {
    // Сохраняем данные пользователя (БЕЗ пароля) в SharedPreferences
    await _dataSource.register(user);
    
    _currentUser = user;
    // Сохраняем состояние входа
    await _sharedPrefs.saveLoginState(user.login);
    // Здесь можно сохранить токен авторизации (если используется токен-авторизация)
    // await _secureStorage.saveAuthToken(token);
    
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
    
    // Очищаем токены
    await _secureStorage.deleteAuthToken();
    await _secureStorage.deleteRefreshToken();
    
    print('✅ Пользователь вышел из системы.');
  }

  @override
  Future<User?> getCurrentUser() async {
    // Проверяем сохраненное состояние
    final isLoggedIn = await _sharedPrefs.isLoggedIn();
    if (isLoggedIn && _currentUser == null) {
      final login = await _sharedPrefs.getCurrentLogin();
      if (login != null) {
        // Проверяем наличие токена для автологина
        final authToken = await _secureStorage.getAuthToken();
        if (authToken != null) {
          // Если токен есть, восстанавливаем пользователя из SharedPreferences
          final userData = await _sharedPrefs.getUserData(login);
          if (userData['phone'] != null || userData['email'] != null) {
            final user = User(
              login: login,
              password: '', // Пароль не сохраняется
              phone: userData['phone'],
              email: userData['email'],
              region: userData['region'],
              city: userData['city'],
              address: userData['address'],
            );
            _currentUser = user;
          }
        }
      }
    }
    return _currentUser ?? await _dataSource.getCurrentUser();
  }
}

