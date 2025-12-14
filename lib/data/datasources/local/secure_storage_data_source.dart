import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDataSource {
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

  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';

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


