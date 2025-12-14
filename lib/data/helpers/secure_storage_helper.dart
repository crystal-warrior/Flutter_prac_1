import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// SecureStorageHelper - низкоуровневый класс для работы с Flutter Secure Storage
class SecureStorageHelper {
  static SecureStorageHelper? _instance;
  
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

  SecureStorageHelper._internal();

  factory SecureStorageHelper() {
    _instance ??= SecureStorageHelper._internal();
    return _instance!;
  }


  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      if (kDebugMode) {
        print(' Значение сохранено в SecureStorage: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        print(' Ошибка сохранения в SecureStorage для ключа $key: $e');
      }
      rethrow;
    }
  }

  /// Получение значения по ключу
  Future<String?> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (kDebugMode && value != null) {
        print(' Значение прочитано из SecureStorage: $key');
      }
      return value;
    } catch (e) {
      if (kDebugMode) {
        print('Ошибка чтения из SecureStorage для ключа $key: $e');
      }
      return null;
    }
  }

  /// Удаление значения по ключу
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      if (kDebugMode) {
        print('Значение удалено из SecureStorage: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        print(' Ошибка удаления из SecureStorage для ключа $key: $e');
      }
    }
  }

  /// Проверка наличия ключа
  Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      if (kDebugMode) {
        print(' Ошибка проверки ключа в SecureStorage: $key, $e');
      }
      return false;
    }
  }

  /// Получение всех ключей
  Future<Map<String, String>> readAll() async {
    try {
      final all = await _storage.readAll();
      if (kDebugMode) {
        print(' Прочитано ${all.length} значений из SecureStorage');
      }
      return all;
    } catch (e) {
      if (kDebugMode) {
        print(' Ошибка чтения всех значений из SecureStorage: $e');
      }
      return {};
    }
  }

  /// Удаление всех значений
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
      if (kDebugMode) {
        print(' Все значения удалены из SecureStorage');
      }
    } catch (e) {
      if (kDebugMode) {
        print(' Ошибка удаления всех значений из SecureStorage: $e');
      }
      rethrow;
    }
  }
}

