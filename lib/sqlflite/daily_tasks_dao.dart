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

  Future<List<DailyTask>> getDailyTasks() async {
    final db = await _dbManager.database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final startOfNextDay = startOfDay.add(const Duration(days: 1));
    final rows = await db.query(
      'daily_tasks',
      columns: ['type', 'date'],
      where: 'date >= ? AND date < ?',
      whereArgs: [
        startOfDay.toIso8601String(),
        startOfNextDay.toIso8601String(),
      ],
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

  Future<DailyTask> insertDailyTasks(DailyTask task) async {
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
  Future<Map<int, int>> getCompletionCounts() async {
    final db = await _dbManager.database;
    final rows = await db.rawQuery(
      'SELECT type, COUNT(*) as count FROM daily_tasks GROUP BY type',
    );
    final counts = <int, int>{};
    for (final row in rows) {
      final type = row['type'] as int?;
      final countValue = row['count'];
      if (type == null || countValue == null) {
        continue;
      }
      counts[type] = (countValue as int?) ?? int.parse(countValue.toString());
    }
    for (var i = 0; i < _defaultTasks.length; i++) {
      final type = i + 1;
      counts.putIfAbsent(type, () => 0);
    }
    return counts;
  }
  Future<List<DateTime>> getCompletionDatesForType(int type) async {
    final db = await _dbManager.database;
    final rows = await db.query(
      'daily_tasks',
      columns: ['date'],
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'date DESC',
    );
    final dates = <DateTime>{};
    for (final row in rows) {
      final dateValue = row['date'] as String?;
      if (dateValue == null) {
        continue;
      }
      final parsed = DateTime.parse(dateValue);
      dates.add(DateTime(parsed.year, parsed.month, parsed.day));
    }
    final sortedDates = dates.toList()
      ..sort((a, b) => a.compareTo(b));
    return sortedDates;
  }
  Future<void> update(DailyTask task) async {
    await insertDailyTasks(task);
  }
}