import 'package:sqflite/sqflite.dart';
import '/data_types/achievement_record.dart';
import '/data_types/achivement_data.dart';
import 'database_manager.dart';
import '/main/service_locator.dart';

class AchievementDao {
  final DatabaseManager _dbManager = getIt<DatabaseManager>();

  Future<void> ensureInitialized() async {
    final db = await _dbManager.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS achievement_record (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        is_achieved INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        achievement_date TEXT
      )
    ''');

    final existing = await db.query('achievement_record');
    if (existing.isEmpty) {
      for (var achievement in startingAchievements) {
        await db.insert('achievement_record', achievement.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<List<AchievementRecord>> getAll() async {
    final db = await _dbManager.database;
    final maps = await db.query('achievement_record');
    return maps.map((e) => AchievementRecord.fromMap(e)).toList();
  }

  Future<void> activate(int id) async {
    final db = await _dbManager.database;
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

  Future<void> insertMany(List<AchievementRecord> achievements) async {
    final db = await _dbManager.database;
    for (var ach in achievements) {
      await db.insert('achievement_record', ach.toMap());
    }
  }
}
