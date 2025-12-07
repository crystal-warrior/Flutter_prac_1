import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../../../core/models/planting_event.dart';
import 'dto/planting_event_dto.dart';
import 'mappers/planting_event_mapper.dart';
import 'shared_preferences_data_source.dart';

class SqlitePlantingCalendarDataSource {
  static const String _tableName = 'planting_events';
  static const int _databaseVersion = 2;
  
  Database? _database;
  final SharedPreferencesDataSource? _sharedPrefs;

  SqlitePlantingCalendarDataSource({SharedPreferencesDataSource? sharedPrefs}) 
      : _sharedPrefs = sharedPrefs;

  Future<Database?> get database async {
    if (kIsWeb) {
      // На веб SQLite недоступен, используем SharedPreferences
      return null;
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite не поддерживается на веб-платформе');
    }
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'planting_calendar.db');

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
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {

      await db.execute('''
        ALTER TABLE $_tableName ADD COLUMN user_login TEXT
      ''');

      await db.delete(_tableName, where: 'user_login IS NULL');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_user_login ON $_tableName(user_login)
      ''');
    }
  }

  // Получение всех событий для конкретного пользователя
  Future<Map<String, List<PlantingEvent>>> getEvents(String userLogin) async {
    if (kIsWeb) {
      // На веб используем SharedPreferences
      return await _getEventsFromSharedPrefs(userLogin);
    }
    
    final db = await database;
    if (db == null) {
      return {};
    }
    
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'user_login = ?',
      whereArgs: [userLogin],
    );

    print('📅 Загружено событий из БД для пользователя $userLogin: ${maps.length}');
    
    final Map<String, List<PlantingEvent>> eventsMap = {};
    
    for (final map in maps) {
      // Преобразуем Map в DTO
      final dto = PlantingEventDto.fromMap(map);
      // Преобразуем DTO в доменную модель
      final event = dto.toDomain();
      
      final dateKey = event.dateKey;
      print('📌 Событие: dateKey=$dateKey, date=${dto.date}, note=${dto.note}');
      eventsMap.putIfAbsent(dateKey, () => []).add(event);
    }

    print('🗺️ Итоговая карта событий: ${eventsMap.keys.toList()}');
    return eventsMap;
  }

  // Получение событий из SharedPreferences (для веб)
  Future<Map<String, List<PlantingEvent>>> _getEventsFromSharedPrefs(String userLogin) async {
    if (_sharedPrefs == null) {
      print('⚠️ SharedPreferences недоступен для веб-платформы');
      return {};
    }
    
    try {
      final eventsJson = await _sharedPrefs.getPlantingEvents(userLogin);
      if (eventsJson == null || eventsJson.isEmpty) {
        return {};
      }
      
      // Парсим JSON и преобразуем в Map
      final Map<String, List<PlantingEvent>> eventsMap = {};
      
      for (final entry in eventsJson.entries) {
        final dateKey = entry.key;
        final eventsList = entry.value as List;
        eventsMap[dateKey] = eventsList
            .map((e) {
              try {
                final dto = PlantingEventDto.fromJson(e as Map<String, dynamic>);
                return dto.toDomain();
              } catch (e2) {
                print('❌ Ошибка при преобразовании события: $e2');
                return null;
              }
            })
            .whereType<PlantingEvent>()
            .toList();
      }
      
      print('📅 Загружено событий из SharedPreferences для пользователя $userLogin: ${eventsMap.length}');
      return eventsMap;
    } catch (e) {
      print('❌ Ошибка при загрузке событий из SharedPreferences: $e');
      return {};
    }
  }

  // Получение событий для конкретной даты и пользователя
  Future<List<PlantingEvent>> getEventsForDate(DateTime date, String userLogin) async {
    if (kIsWeb) {
      // На веб используем SharedPreferences
      final allEvents = await _getEventsFromSharedPrefs(userLogin);
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return allEvents[dateKey] ?? [];
    }
    
    final db = await database;
    if (db == null) {
      return [];
    }
    
    final dateStr = date.toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'date LIKE ? AND user_login = ?',
      whereArgs: ['$dateStr%', userLogin],
    );

    // Преобразуем Map в DTO, затем в доменные модели
    return maps
        .map((map) => PlantingEventDto.fromMap(map))
        .map((dto) => dto.toDomain())
        .toList();
  }

  // Добавление события для конкретного пользователя
  Future<void> addEvent(PlantingEvent event, String userLogin) async {
    if (kIsWeb) {
      // На веб используем SharedPreferences
      await _addEventToSharedPrefs(event, userLogin);
      return;
    }
    
    final db = await database;
    if (db == null) {
      throw Exception('База данных недоступна');
    }
    
    // Преобразуем доменную модель в DTO
    final dto = event.toDto(userLogin);
    // Преобразуем DTO в Map для вставки в БД
    final id = await db.insert(
      _tableName,
      dto.toMap(),
    );
    print('✅ Событие добавлено в БД: id=$id, date=${dto.date}, user=$userLogin, note=${dto.note}');
  }

  // Добавление события в SharedPreferences (для веб)
  Future<void> _addEventToSharedPrefs(PlantingEvent event, String userLogin) async {
    if (_sharedPrefs == null) {
      throw Exception('SharedPreferences недоступен для веб-платформы');
    }
    
    try {
      // Получаем текущие события
      final eventsMap = await _getEventsFromSharedPrefs(userLogin);
      
      // Добавляем новое событие
      final dateKey = event.dateKey;
      eventsMap.putIfAbsent(dateKey, () => []).add(event);
      
      // Сохраняем обратно в SharedPreferences
      final eventsJson = <String, List<Map<String, dynamic>>>{};
      for (final entry in eventsMap.entries) {
        eventsJson[entry.key] = entry.value
            .map((e) {
              final dto = e.toDto(userLogin);
              return dto.toJson();
            })
            .toList();
      }
      
      await _sharedPrefs.savePlantingEvents(userLogin, eventsJson);
      print('✅ Событие добавлено в SharedPreferences: dateKey=$dateKey, user=$userLogin, note=${event.note}');
    } catch (e) {
      print('❌ Ошибка при добавлении события в SharedPreferences: $e');
      rethrow;
    }
  }

  // Удаление события по ID (используется только для SQLite)
  Future<void> deleteEvent(int id) async {
    if (kIsWeb) {
      // На веб удаление по ID не поддерживается
      return;
    }
    
    final db = await database;
    if (db == null) {
      return;
    }
    
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Удаление события по dateKey и индексу (для веб)
  Future<void> deleteEventByDateKey(String dateKey, int index, String userLogin) async {
    if (!kIsWeb || _sharedPrefs == null) {
      return;
    }
    
    try {
      final eventsMap = await _getEventsFromSharedPrefs(userLogin);
      if (eventsMap.containsKey(dateKey) && index >= 0 && index < eventsMap[dateKey]!.length) {
        eventsMap[dateKey]!.removeAt(index);
        if (eventsMap[dateKey]!.isEmpty) {
          eventsMap.remove(dateKey);
        }
        
        // Сохраняем обратно
        final eventsJson = <String, List<Map<String, dynamic>>>{};
        for (final entry in eventsMap.entries) {
          eventsJson[entry.key] = entry.value
              .map((e) {
                final dto = e.toDto(userLogin);
                return dto.toJson();
              })
              .toList();
        }
        
        await _sharedPrefs.savePlantingEvents(userLogin, eventsJson);
        print('✅ Событие удалено из SharedPreferences: dateKey=$dateKey, index=$index');
      }
    } catch (e) {
      print('❌ Ошибка при удалении события из SharedPreferences: $e');
      rethrow;
    }
  }

  // Удаление всех событий
  Future<void> deleteAllEvents() async {
    if (kIsWeb) {
      // На веб удаление всех событий не поддерживается
      return;
    }
    
    final db = await database;
    if (db == null) {
      return;
    }
    
    await db.delete(_tableName);
  }

  // Получение ID события по дате, индексу и пользователю
  Future<int?> getEventId(String dateKey, int index, String userLogin) async {
    if (kIsWeb) {
      // На веб ID не используется, возвращаем индекс
      return index;
    }
    
    final dateParts = dateKey.split('-');
    if (dateParts.length != 3) return null;
    
    final date = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
    );
    
    // Получаем все события для этой даты и пользователя из БД и находим нужный ID
    final db = await database;
    if (db == null) {
      return null;
    }
    
    final dateStr = date.toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'date LIKE ? AND user_login = ?',
      whereArgs: ['$dateStr%', userLogin],
      orderBy: 'id',
    );
    
    if (index >= 0 && index < maps.length) {
      return maps[index]['id'] as int;
    }
    return null;
  }
}

