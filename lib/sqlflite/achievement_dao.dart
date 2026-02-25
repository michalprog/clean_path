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
        icon_codepoint INTEGER NOT NULL DEFAULT 59448,
        icon_font_family TEXT,
        icon_font_package TEXT,
        rarity TEXT NOT NULL DEFAULT 'common',
        achievement_date TEXT
      )
    ''');

    final tableInfo = await db.rawQuery('PRAGMA table_info(achievement_record)');
    final columnNames = tableInfo
        .map((row) => row['name'] as String?)
        .whereType<String>()
        .toSet();

    if (!columnNames.contains('icon_font_family')) {
      await db.execute(
        'ALTER TABLE achievement_record ADD COLUMN icon_font_family TEXT',
      );
    }

    if (!columnNames.contains('icon_font_package')) {
      await db.execute(
        'ALTER TABLE achievement_record ADD COLUMN icon_font_package TEXT',
      );
    }

    final existing = await db.query('achievement_record', columns: ['id']);
    final existingIds = existing
        .map((row) => row['id'] as int?)
        .whereType<int>()
        .toSet();

    for (final achievement in startingAchievements) {
      if (existingIds.contains(achievement.id)) {
        continue;
      }
      await db.insert(
        'achievement_record',
        achievement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<AchievementRecord>> getAll() async {
    final db = await _dbManager.database;
    final maps = await db.query('achievement_record');
    return maps.map((e) => AchievementRecord.fromMap(e)).toList();
  }

  Future<void> activateAchievement(int id) async {
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
