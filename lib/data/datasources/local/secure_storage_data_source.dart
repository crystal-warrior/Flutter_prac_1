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


  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }


  Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyAuthToken);
  }


  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _keyAuthToken);
  }


  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }


  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }


  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}


