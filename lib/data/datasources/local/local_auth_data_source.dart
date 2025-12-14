import '../../../../core/models/user.dart';
import 'shared_preferences_data_source.dart';
import 'secure_storage_data_source.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class LocalAuthDataSource {
  final Map<String, User> _usersCache = {};
  final SharedPreferencesDataSource _sharedPrefs;
  final SecureStorageDataSource _secureStorage;

  LocalAuthDataSource(this._sharedPrefs, this._secureStorage);

  /// Аутентификация по логину и паролю
  Future<User?> authenticate(String login, String password) async {

    final isRegistered = await _sharedPrefs.isUserRegistered(login);
    if (!isRegistered) {
      print('Пользователь $login не зарегистрирован');
      return null;
    }


    final userData = await _sharedPrefs.getUserData(login);
    

    final user = User(
      login: login,
      password: password, // Пароль передается, но не сохраняется
      phone: userData['phone'],
      email: userData['email'],
      region: userData['region'],
      city: userData['city'],
      address: userData['address'],
    );
    
    // Генерируем и сохраняем токены при успешной аутентификации
    await _generateAndSaveTokens(login);
    
    _usersCache[login] = user.copyWith(password: '');
    
    print('Пользователь $login успешно аутентифицирован');
    return user;
  }

  /// Аутентификация по токену
  Future<User?> authenticateByToken() async {

    final authToken = await _secureStorage.getAuthToken();
    if (authToken == null) {
      print('Токен авторизации не найден');
      return null;
    }


    if (!_isTokenValid(authToken)) {
      print('Токен авторизации истек');

      final refreshed = await _refreshToken();
      if (!refreshed) {
        await _secureStorage.deleteAuthToken();
        await _secureStorage.deleteRefreshToken();
        return null;
      }
    }


    final login = _extractLoginFromToken(authToken);
    if (login == null) {
      print('Не удалось извлечь логин из токена');
      return null;
    }

    // Проверяем, зарегистрирован ли пользователь
    final isRegistered = await _sharedPrefs.isUserRegistered(login);
    if (!isRegistered) {
      print('Пользователь $login не зарегистрирован');
      return null;
    }

    // Получаем данные пользователя
    final userData = await _sharedPrefs.getUserData(login);
    
    final user = User(
      login: login,
      password: '', // Пароль не используется при аутентификации по токену
      phone: userData['phone'],
      email: userData['email'],
      region: userData['region'],
      city: userData['city'],
      address: userData['address'],
    );
    
    _usersCache[login] = user;
    
    print('Пользователь $login успешно аутентифицирован по токену');
    return user;
  }

  /// Регистрация нового пользователя
  Future<void> register(User user) async {
    await _sharedPrefs.saveUserData(
      user.login,
      user.phone,
      user.email,
      user.region,
      user.city,
      user.address,
    );
    
    // Генерируем и сохраняем токены при регистрации
    await _generateAndSaveTokens(user.login);
    
    _usersCache[user.login] = user.copyWith(password: '');
    
    print('Пользователь ${user.login} успешно зарегистрирован');
  }

  /// Получение текущего пользователя
  Future<User?> getCurrentUser() async {
    // Сначала пытаемся получить из кэша
    if (_usersCache.isNotEmpty) {
      return _usersCache.values.first;
    }
    
    // Если в кэше нет, пытаемся аутентифицировать по токену
    return await authenticateByToken();
  }

  /// Генерация и сохранение токенов
  Future<void> _generateAndSaveTokens(String login) async {
    // Генерируем простой токен на основе логина и времени (в реальном приложении используется JWT)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final authToken = _generateToken(login, timestamp);
    final refreshToken = _generateRefreshToken(login, timestamp);
    
    await _secureStorage.saveAuthToken(authToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    
    print('Токены сгенерированы и сохранены для пользователя $login');
  }

  /// Генерация токена авторизации
  String _generateToken(String login, int timestamp) {
    // В реальном приложении здесь был бы JWT токен
    // Для демонстрации создаем простой токен
    final data = '$login:$timestamp:auth';
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return base64.encode(utf8.encode('$login:$timestamp:${hash.toString()}'));
  }

  /// Генерация refresh токена
  String _generateRefreshToken(String login, int timestamp) {
    final data = '$login:$timestamp:refresh';
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return base64.encode(utf8.encode('$login:$timestamp:${hash.toString()}'));
  }

  /// Проверка валидности токена
  bool _isTokenValid(String token) {
    try {
      final decoded = utf8.decode(base64.decode(token));
      final parts = decoded.split(':');
      if (parts.length < 3) return false;
      
      final timestamp = int.tryParse(parts[1]);
      if (timestamp == null) return false;
      
      // Токен действителен 7 дней
      final tokenTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(tokenTime);
      
      return difference.inDays < 7;
    } catch (e) {
      print('Ошибка проверки токена: $e');
      return false;
    }
  }

  /// Извлечение логина из токена
  String? _extractLoginFromToken(String token) {
    try {
      final decoded = utf8.decode(base64.decode(token));
      final parts = decoded.split(':');
      if (parts.isNotEmpty) {
        return parts[0];
      }
    } catch (e) {
      print('Ошибка извлечения логина из токена: $e');
    }
    return null;
  }

  /// Обновление токена через refresh token
  Future<bool> _refreshToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) {
      return false;
    }

    if (!_isTokenValid(refreshToken)) {
      print('Refresh токен истек');
      return false;
    }

    final login = _extractLoginFromToken(refreshToken);
    if (login == null) {
      return false;
    }

    // Генерируем новые токены
    await _generateAndSaveTokens(login);
    print('Токены обновлены для пользователя $login');
    return true;
  }

  /// Выход из системы (очистка токенов)
  Future<void> logout() async {
    await _secureStorage.deleteAuthToken();
    await _secureStorage.deleteRefreshToken();
    _usersCache.clear();
    print('Токены удалены, пользователь вышел из системы');
  }
}


