import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// SharedPreferencesHelper - низкоуровневый класс для работы с SharedPreferences
/// Инкапсулирует всю логику работы с ключами и значениями
class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;
  SharedPreferences? _prefs;

  SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    _instance ??= SharedPreferencesHelper._internal();
    return _instance!;
  }


  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }


  Future<SharedPreferences> get prefs async {
    await init();
    return _prefs!;
  }




  Future<bool> setString(String key, String value) async {
    final prefs = await this.prefs;
    return await prefs.setString(key, value);
  }


  Future<String?> getString(String key) async {
    final prefs = await this.prefs;
    return prefs.getString(key);
  }


  Future<bool> setBool(String key, bool value) async {
    final prefs = await this.prefs;
    return await prefs.setBool(key, value);
  }


  Future<bool?> getBool(String key) async {
    final prefs = await this.prefs;
    return prefs.getBool(key);
  }


  Future<bool> setInt(String key, int value) async {
    final prefs = await this.prefs;
    return await prefs.setInt(key, value);
  }


  Future<int?> getInt(String key) async {
    final prefs = await this.prefs;
    return prefs.getInt(key);
  }

  /// Сохранение числа с плавающей точкой
  Future<bool> setDouble(String key, double value) async {
    final prefs = await this.prefs;
    return await prefs.setDouble(key, value);
  }

  /// Получение числа с плавающей точкой
  Future<double?> getDouble(String key) async {
    final prefs = await this.prefs;
    return prefs.getDouble(key);
  }

  /// Сохранение списка строк
  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await this.prefs;
    return await prefs.setStringList(key, value);
  }

  /// Получение списка строк
  Future<List<String>?> getStringList(String key) async {
    final prefs = await this.prefs;
    return prefs.getStringList(key);
  }

  /// Удаление значения по ключу
  Future<bool> remove(String key) async {
    final prefs = await this.prefs;
    return await prefs.remove(key);
  }

  /// Проверка наличия ключа
  Future<bool> containsKey(String key) async {
    final prefs = await this.prefs;
    return prefs.containsKey(key);
  }

  /// Получение всех ключей
  Future<Set<String>> getKeys() async {
    final prefs = await this.prefs;
    return prefs.getKeys();
  }

  /// Очистка всех данных
  Future<bool> clear() async {
    final prefs = await this.prefs;
    return await prefs.clear();
  }

  // ========== Работа с JSON ==========

  /// Сохранение объекта в формате JSON
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка сохранения JSON для ключа $key: $e');
      }
      return false;
    }
  }

  /// Получение объекта из JSON
  Future<Map<String, dynamic>?> getJson(String key) async {
    try {
      final jsonString = await getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка чтения JSON для ключа $key: $e');
      }
      return null;
    }
  }

  /// Сохранение списка объектов в формате JSON
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка сохранения JSON списка для ключа $key: $e');
      }
      return false;
    }
  }

  /// Получение списка объектов из JSON
  Future<List<Map<String, dynamic>>?> getJsonList(String key) async {
    try {
      final jsonString = await getString(key);
      if (jsonString == null) return null;
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка чтения JSON списка для ключа $key: $e');
      }
      return null;
    }
  }

  // ========== Работа с датами ==========

  /// Сохранение даты в формате ISO8601
  Future<bool> setDateTime(String key, DateTime value) async {
    return await setString(key, value.toIso8601String());
  }

  /// Получение даты из ISO8601 строки
  Future<DateTime?> getDateTime(String key) async {
    final dateString = await getString(key);
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка парсинга даты для ключа $key: $e');
      }
      return null;
    }
  }
}

