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
    final isLoggedIn = await _sharedPrefs.isLoggedIn();
    if (isLoggedIn) {
      final login = await _sharedPrefs.getCurrentLogin();
      if (login != null) {

        final password = await _secureStorage.getPassword(login);
        if (password != null) {
          final user = await _dataSource.authenticate(login, password);
          if (user != null) {
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
      // Пытаемся сохранить пароль в безопасном хранилище для автологина
      // На веб-платформе это может не работать между сессиями - это нормальное ограничение
      try {
        await _secureStorage.savePassword(login, password);
      } catch (e) {
        // Не критично, если не удалось сохранить - это ожидаемое поведение на веб
        print('⚠️ Не удалось сохранить пароль для автологина: $e');
      }
    }
    return user;
  }

  @override
  Future<void> register(User user) async {
    // Сначала сохраняем данные пользователя (БЕЗ пароля) в SharedPreferences
    await _dataSource.register(user);
    
    // Пытаемся сохранить пароль в безопасном хранилище
    // На веб-платформе это может не работать между сессиями - это нормальное ограничение безопасности
    try {
      await _secureStorage.savePassword(user.login, user.password);
      // Проверяем, что пароль действительно сохранился (только для отладки)
      final savedPassword = await _secureStorage.getPassword(user.login);
      if (savedPassword != user.password) {
        print('⚠️ Пароль не сохранился для пользователя ${user.login}');
        print('ℹ️ На веб-платформе пароли могут не сохраняться между сессиями - это нормальное ограничение безопасности.');
      }
    } catch (e) {
      // Не выбрасываем исключение - это ожидаемое поведение на веб
      print('⚠️ Не удалось сохранить пароль в SecureStorage для ${user.login}: $e');
      print('ℹ️ На веб-платформе пароли могут не сохраняться между сессиями - это нормальное ограничение безопасности.');
    }
    
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
    
    // Очищаем только состояние входа (isLoggedIn)
    // НЕ удаляем пароль из SecureStorage, чтобы пользователь мог войти снова
    await _sharedPrefs.clearLoginState();
    
    // Очищаем токены (если используются)
    await _secureStorage.deleteAuthToken();
    await _secureStorage.deleteRefreshToken();
    
    print('✅ Пользователь вышел из системы. Пароль сохранен для повторного входа.');
  }

  @override
  Future<User?> getCurrentUser() async {
    // Сначала проверяем сохраненное состояние
    final isLoggedIn = await _sharedPrefs.isLoggedIn();
    if (isLoggedIn && _currentUser == null) {
      final login = await _sharedPrefs.getCurrentLogin();
      if (login != null) {
        // Пытаемся восстановить пользователя
        final password = await _secureStorage.getPassword(login);
        if (password != null) {
          final user = await _dataSource.authenticate(login, password);
          if (user != null) {
            _currentUser = user;
          }
        }
      }
    }
    return _currentUser ?? await _dataSource.getCurrentUser();
  }
}

