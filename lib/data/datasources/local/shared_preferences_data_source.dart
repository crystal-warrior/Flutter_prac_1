import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesDataSource {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyCurrentLogin = 'current_login';
  static const String _keyLastLoginTime = 'last_login_time';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  // Сохранение состояния входа
  Future<void> saveLoginState(String login) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyCurrentLogin, login);
    await prefs.setString(_keyLastLoginTime, DateTime.now().toIso8601String());
  }

  // Получение состояния входа
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Получение текущего логина
  Future<String?> getCurrentLogin() async {
    final prefs = await _prefs;
    return prefs.getString(_keyCurrentLogin);
  }

  // Получение времени последнего входа
  Future<DateTime?> getLastLoginTime() async {
    final prefs = await _prefs;
    final timeString = prefs.getString(_keyLastLoginTime);
    if (timeString != null) {
      return DateTime.parse(timeString);
    }
    return null;
  }

  // Выход из системы
  Future<void> clearLoginState() async {
    final prefs = await _prefs;
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyCurrentLogin);
    await prefs.remove(_keyLastLoginTime);
  }

  // Сохранение настроек темы (глобальная тема, для обратной совместимости)
  Future<void> saveThemeMode(String themeMode) async {
    final prefs = await _prefs;
    await prefs.setString(_keyThemeMode, themeMode);
  }

  // Получение настроек темы (глобальная тема, для обратной совместимости)
  Future<String?> getThemeMode() async {
    final prefs = await _prefs;
    return prefs.getString(_keyThemeMode);
  }

  // Сохранение темы для конкретного пользователя
  Future<void> saveUserThemeMode(String login, String themeMode) async {
    final prefs = await _prefs;
    final userKey = 'user_$login';
    await prefs.setString('${userKey}_theme', themeMode);
    // Также сохраняем как текущую тему
    await prefs.setString(_keyThemeMode, themeMode);
  }

  // Получение темы для конкретного пользователя
  Future<String?> getUserThemeMode(String login) async {
    final prefs = await _prefs;
    final userKey = 'user_$login';
    return prefs.getString('${userKey}_theme');
  }

  // Сброс темы на дефолтную
  Future<void> resetThemeMode() async {
    final prefs = await _prefs;
    await prefs.setString(_keyThemeMode, 'dayGarden');
  }

  // Сохранение языка
  Future<void> saveLanguage(String language) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLanguage, language);
  }

  // Получение языка
  Future<String?> getLanguage() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLanguage);
  }

  // Сохранение данных пользователя (без пароля)
  Future<void> saveUserData(String login, String? phone, String? email, String? region, String? city, String? address) async {
    final prefs = await _prefs;
    final userKey = 'user_$login';
    await prefs.setString('${userKey}_phone', phone ?? '');
    await prefs.setString('${userKey}_email', email ?? '');
    await prefs.setString('${userKey}_region', region ?? '');
    await prefs.setString('${userKey}_city', city ?? '');
    await prefs.setString('${userKey}_address', address ?? '');
    
    // Сохраняем список зарегистрированных пользователей
    final registeredUsers = prefs.getStringList('registered_users') ?? [];
    if (!registeredUsers.contains(login)) {
      registeredUsers.add(login);
      await prefs.setStringList('registered_users', registeredUsers);
    }
  }

  // Получение данных пользователя (без пароля)
  Future<Map<String, String?>> getUserData(String login) async {
    final prefs = await _prefs;
    final userKey = 'user_$login';
    
    // Получаем значения, пустые строки преобразуем в null
    String? getValueOrNull(String key) {
      final value = prefs.getString(key);
      return (value != null && value.isNotEmpty) ? value : null;
    }
    
    return {
      'phone': getValueOrNull('${userKey}_phone'),
      'email': getValueOrNull('${userKey}_email'),
      'region': getValueOrNull('${userKey}_region'),
      'city': getValueOrNull('${userKey}_city'),
      'address': getValueOrNull('${userKey}_address'),
    };
  }

  // Проверка, зарегистрирован ли пользователь
  Future<bool> isUserRegistered(String login) async {
    final prefs = await _prefs;
    final registeredUsers = prefs.getStringList('registered_users') ?? [];
    return registeredUsers.contains(login);
  }

  // Получение списка всех зарегистрированных пользователей
  Future<List<String>> getRegisteredUsers() async {
    final prefs = await _prefs;
    return prefs.getStringList('registered_users') ?? [];
  }

  // Fallback методы для хранения паролей (используются если SecureStorage не работает)
  static const String _keyPasswordPrefix = 'secure_password_';

  Future<void> savePasswordFallback(String login, String password) async {
    final prefs = await _prefs;
    await prefs.setString('$_keyPasswordPrefix$login', password);
  }

  Future<String?> getPasswordFallback(String login) async {
    final prefs = await _prefs;
    return prefs.getString('$_keyPasswordPrefix$login');
  }

  Future<void> deletePasswordFallback(String login) async {
    final prefs = await _prefs;
    await prefs.remove('$_keyPasswordPrefix$login');
  }

  // Методы для хранения событий календаря посадок (для веб-платформы)
  static const String _keyPlantingEventsPrefix = 'planting_events_';

  Future<void> savePlantingEvents(String userLogin, Map<String, List<Map<String, dynamic>>> events) async {
    final prefs = await _prefs;
    final key = '$_keyPlantingEventsPrefix$userLogin';
    // Преобразуем Map в JSON-совместимую структуру
    final eventsJson = <String, dynamic>{};
    for (final entry in events.entries) {
      eventsJson[entry.key] = entry.value;
    }
    await prefs.setString(key, jsonEncode(eventsJson));
  }

  Future<Map<String, dynamic>?> getPlantingEvents(String userLogin) async {
    final prefs = await _prefs;
    final key = '$_keyPlantingEventsPrefix$userLogin';
    final eventsJson = prefs.getString(key);
    if (eventsJson == null || eventsJson.isEmpty) {
      return null;
    }
    try {
      return jsonDecode(eventsJson) as Map<String, dynamic>;
    } catch (e) {
      print('❌ Ошибка при парсинге событий из SharedPreferences: $e');
      return null;
    }
  }
}


