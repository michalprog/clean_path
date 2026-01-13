import 'package:sqflite/sqflite.dart';
import '/data_types/daily_task.dart';
import '/main/service_locator.dart';
import 'database_manager.dart';

class DailyTasksDao {
  final DatabaseManager _dbManager = getIt<DatabaseManager>();

  static const List<String> _defaultTasks = [
    'hydration',
    'workout',
    'meditation',
    'learning',
  ];


  Future<void> ensureInitialized() async {
    final db = await _dbManager.database;
    final legacyTable = await db.query(
      'sqlite_master',
      columns: ['name'],
      where: 'type = ? AND name = ?',
      whereArgs: ['table', 'daily_task'],
      limit: 1,
    );

    if (legacyTable.isEmpty) {
      return;
    }

    final legacyRows = await db.query('daily_task');
    for (final row in legacyRows) {
      final title = row['title'] as String?;
      final lastCompleted = row['last_completed'] as String?;
      final typeIndex = _defaultTasks.indexOf(title ?? '');
      if (typeIndex == -1 || lastCompleted == null) {
        continue;
      }
      await db.insert(
        'daily_tasks',
        {
          'type': typeIndex + 1,
          'date': lastCompleted,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await db.execute('DROP TABLE IF EXISTS daily_task');
  }

  Future<List<DailyTask>> getAll() async {
    final db = await _dbManager.database;
    final rows = await db.query(
      'daily_tasks',
      columns: ['type', 'date'],
      orderBy: 'date DESC',
    );

    final Map<int, DateTime> latestByType = {};
    for (final row in rows) {
      final type = row['type'] as int?;
      final dateValue = row['date'] as String?;
      if (type == null || dateValue == null) {
        continue;
      }
      latestByType.putIfAbsent(type, () => DateTime.parse(dateValue));
    }

    return List<DailyTask>.generate(_defaultTasks.length, (index) {
      final type = index + 1;
      return DailyTask(
        type: type,
        title: _defaultTasks[index],
        lastCompleted: latestByType[type],
      );
    });
  }

  Future<DailyTask> insert(DailyTask task) async {
    final db = await _dbManager.database;
    final completionDate = task.lastCompleted ?? DateTime.now();
    final normalizedDate = DateTime(
      completionDate.year,
      completionDate.month,
      completionDate.day,
    );
    final startOfDay = normalizedDate.toIso8601String();
    final startOfNextDay =
    normalizedDate.add(const Duration(days: 1)).toIso8601String();
    await db.delete(
      'daily_tasks',
      where: 'type = ? AND date >= ? AND date < ?',
      whereArgs: [task.type, startOfDay, startOfNextDay],
    );
    await db.insert(
      'daily_tasks',
      task.toCompletionMap(normalizedDate),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return task.copyWith(lastCompleted: normalizedDate);
  }

  Future<void> update(DailyTask task) async {
    await insert(task);
  }
}