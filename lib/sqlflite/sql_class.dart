import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data_types/achievement_record.dart';
import '../data_types/achivement_data.dart';
import '/data_types/record.dart';

class SqlClass {
  static Database? _database;

  SqlClass._internal();
  // Singleton - dostęp do jednej instancji
  static final SqlClass instance = SqlClass._internal();

  // Getter do bazy danych
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicjalizacja bazy danych
  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'notes.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Tworzenie tabeli przy pierwszym uruchomieniu
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE record (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type INTEGER NOT NULL,
  is_active INTEGER DEFAULT 1,
  activated TEXT NOT NULL,
  desactivated TEXT
)
    ''');
    await db.execute('''
    CREATE TABLE achievement_record (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      is_achieved INTEGER NOT NULL,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      achievement_date TEXT
    )
  ''');
    insertAchievements(startingAchievements);
  }

  Future<Record> insertRecord(Record record) async {
    final db = await database;
    int id = await db.insert('record', record.toMapForInsert());
    return Record(
      id,
      record.type,
      record.isActive,
      record.activated,
      desactivated: record.desactivated,
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<Record?> getRecord(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'record',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Record.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Record>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('record');

    return List.generate(maps.length, (i) {
      return Record.fromMap(maps[i]);
    });
  }


  Future<Record?> getActiveRecordByType(int type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'record',
      where: 'type = ? AND is_active = ?',
      whereArgs: [type, 1],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Record.fromMap(maps.first);
    }
    return null;
  }
  Future<List<Record>> getActiveRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'record',
      where: 'is_active = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Record.fromMap(maps[i]);
    });
  }

  Future<List<Record>> getRecordsByType(int type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'record',
      where: 'type = ? ',
      whereArgs: [type],
    );

    return List.generate(maps.length, (i) {
      return Record.fromMap(maps[i]);
    });
  }

  Future<void> updateRecord(Record record) async {
    final db = await database;

    await db.update(
      'record',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }
  Future<void> insertAchievements(List<AchievementRecord> achievements) async {
    final db = await database;

    for (var achievement in achievements) {
      await db.insert(
        'achievement_record',
        achievement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Zapobiega duplikatom
      );
    }
  }
  Future<List<AchievementRecord>> getAllAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('achievement_record');

    return List.generate(maps.length, (i) {
      return AchievementRecord.fromMap(maps[i]);
    });
  }
  Future<void> activateAchievement(int id) async {
    final db = await database;

    await db.update(
      'achievement_record',
      {
        'is_achieved': 1,
        'achievement_date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
