import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorageDataSource {
  bool? _isAvailable;

  SecureStorageDataSource();

  static final _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: const IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),

    webOptions: const WebOptions(
      publicKey: 'my_public_key',
    ),
  );

  static const String _keyPassword = 'user_password';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';


  Future<bool> _isSecureStorageAvailable() async {

    if (_isAvailable != null) {
      return _isAvailable!;
    }
    
    try {

      const testKey = '__test_secure_storage__';
      const testValue = 'test';
      await _storage.write(key: testKey, value: testValue);
      final result = await _storage.read(key: testKey);
      await _storage.delete(key: testKey);
      
      _isAvailable = (result == testValue);
      
      if (!_isAvailable! && kDebugMode) {
        print('SecureStorage недоступен');
        print('На веб-платформе пароли могут не сохраняться между сессиями - это нормальное ограничение безопасности.');
      } else if (_isAvailable! && kDebugMode) {
        print('SecureStorage доступен');
      }
      
      return _isAvailable!;
    } catch (e) {
      _isAvailable = false;
      if (kDebugMode) {
        print('⚠SecureStorage недоступен: $e');
        print(' На веб-платформе пароли могут не сохраняться между сессиями - это нормальное ограничение безопасности.');
      }
      return false;
    }
  }

  // Сохранение пароля пользователя
  // ВАЖНО: Пароли хранятся ТОЛЬКО в SecureStorage для безопасности
  // На веб-платформе данные могут не сохраняться между сессиями браузера - это нормальное ограничение безопасности
  Future<void> savePassword(String login, String password) async {
    final isAvailable = await _isSecureStorageAvailable();
    
    if (isAvailable) {
      try {
        await _storage.write(key: '$_keyPassword$login', value: password);
        if (kDebugMode) {
          print('Пароль сохранен в SecureStorage для пользователя: $login');
        }
      } catch (e) {
        if (kDebugMode) {
          print(' Ошибка сохранения пароля в SecureStorage для $login: $e');
          print(' Пароль не был сохранен. На веб-платформе это может быть ограничением безопасности.');
        }
        _isAvailable = false;
        rethrow;
      }
    } else {
      if (kDebugMode) {
        print(' SecureStorage недоступен. Пароль не может быть сохранен безопасно.');
        print('⚠ На веб-платформе пароли могут не сохраняться между сессиями - это нормальное ограничение безопасности.');
      }
      throw Exception('SecureStorage недоступен. Невозможно безопасно сохранить пароль.');
    }
  }

  // Получение пароля пользователя
  // ВАЖНО: Пароли читаются ТОЛЬКО из SecureStorage
  // На веб-платформе данные могут не сохраняться между сессиями браузера
  Future<String?> getPassword(String login) async {
    final isAvailable = await _isSecureStorageAvailable();
    
    if (isAvailable) {
      try {
        final password = await _storage.read(key: '$_keyPassword$login');
        if (password != null) {
          if (kDebugMode) {
            print(' Пароль для $login найден в SecureStorage');
          }
          return password;
        } else {
          if (kDebugMode) {
            print('⚠Пароль для $login не найден в SecureStorage');
            print('ℹНа веб-платформе пароли могут не сохраняться между сессиями браузера - это нормальное ограничение безопасности.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Ошибка чтения пароля из SecureStorage для $login: $e');
        }
        _isAvailable = false;
      }
    } else {
      if (kDebugMode) {
        print(' SecureStorage недоступен. Невозможно прочитать пароль.');
      }
    }
    
    return null;
  }

  // Удаление пароля пользователя
  Future<void> deletePassword(String login) async {
    final isAvailable = await _isSecureStorageAvailable();
    
    if (isAvailable) {
      try {
        await _storage.delete(key: '$_keyPassword$login');
        if (kDebugMode) {
          print(' Пароль для $login удален из SecureStorage');
        }
      } catch (e) {
        if (kDebugMode) {
          print(' Ошибка удаления пароля для $login: $e');
        }
        _isAvailable = false;
      }
    }
  }

  // Сохранение токена авторизации
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  // Получение токена авторизации
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  // Удаление токена авторизации
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _keyAuthToken);
  }

  // Сохранение refresh токена
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  // Получение refresh токена
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  // Удаление refresh токена
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  // Очистка всех данных
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}


