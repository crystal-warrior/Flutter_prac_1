import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// DatabaseHelper - класс для управления SQLite базой данных
class DatabaseHelper {
  static const String _databaseName = 'planting_calendar.db';
  static const int _databaseVersion = 2;
  static const String _tableName = 'planting_events';
  
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database?> get database async {
    if (kIsWeb) {
      return null;
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('');
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
      print('База данных создана: $_databaseName, версия: $version');
    }
  }


  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (kDebugMode) {
      print('Миграция БД с версии $oldVersion на $newVersion');
    }
    
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE $_tableName ADD COLUMN user_login TEXT
      ''');
      
      await db.delete(_tableName, where: 'user_login IS NULL');
      
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_user_login ON $_tableName(user_login)
      ''');
      
      if (kDebugMode) {
        print('Миграция завершена: добавлена колонка user_login');
      }
    }
  }

  /// Получение имени таблицы
  static String get tableName => _tableName;

  /// Выполнение SQL запроса
  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    if (db != null) {
      await db.execute(sql, arguments);
    }
  }

  /// Вставка записи
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    if (db == null) {
      throw Exception('База данных недоступна');
    }
    return await db.insert(table, values);
  }

  /// Запрос данных
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    if (db == null) {
      return [];
    }
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Обновление записей
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    if (db == null) {
      throw Exception('База данных недоступна');
    }
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  /// Удаление записей
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    if (db == null) {
      return 0;
    }
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// Транзакция
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    if (db == null) {
      throw Exception('База данных недоступна');
    }
    return await db.transaction(action);
  }

  /// Закрытие базы данных
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      if (kDebugMode) {
        print('База данных закрыта');
      }
    }
  }
}

