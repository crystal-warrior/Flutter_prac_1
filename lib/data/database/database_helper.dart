import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// DatabaseHelper - класс для управления SQLite базой данных
/// Инкапсулирует всю логику работы с базой данных: инициализацию, миграции, CRUD операции
class DatabaseHelper {
  static const String _databaseName = 'planting_calendar.db';
  static const int _databaseVersion = 2;
  
  static const String _tableName = 'planting_events';
  
  // Singleton паттерн
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  /// Получение экземпляра базы данных (singleton)
  Future<Database?> get database async {
    if (kIsWeb) {
      // На веб SQLite недоступен
      return null;
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Инициализация базы данных
  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite не поддерживается на веб-платформе');
    }
    
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Создание таблиц при первом запуске
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_login TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_user_login ON $_tableName(user_login)
    ''');
    
    if (kDebugMode) {
      print('✅ База данных создана: $_databaseName, версия: $version');
    }
  }

  /// Миграции базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (kDebugMode) {
      print('🔄 Миграция БД с версии $oldVersion на $newVersion');
    }
    
    if (oldVersion < 2) {
      // Добавляем колонку user_login
      await db.execute('''
        ALTER TABLE $_tableName ADD COLUMN user_login TEXT
      ''');
      
      // Удаляем записи, у которых user_login остался NULL после миграции
      await db.delete(_tableName, where: 'user_login IS NULL');
      
      // Создаем индекс для user_login
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_user_login ON $_tableName(user_login)
      ''');
      
      if (kDebugMode) {
        print('✅ Миграция завершена: добавлена колонка user_login');
      }
    }
  }

  /// Получение имени таблицы (для использования в других классах)
  static String get tableName => _tableName;

  /// Закрытие базы данных
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      if (kDebugMode) {
        print('🔒 База данных закрыта');
      }
    }
  }

  /// Очистка базы данных (для тестирования)
  Future<void> clearDatabase() async {
    final db = await database;
    if (db != null) {
      await db.delete(_tableName);
      if (kDebugMode) {
        print('🗑️ База данных очищена');
      }
    }
  }
}

