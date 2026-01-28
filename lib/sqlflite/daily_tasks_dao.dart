import 'package:sqflite/sqflite.dart';
import '/data_types/daily_task.dart';
import '/main/service_locator.dart';
import '/sqlflite/task_progress_dao.dart';
import '/utils_files/task_progress_utils.dart';
import '/data_types/task_progress.dart';
import '/enums/enums.dart';
import 'database_manager.dart';

class DailyTasksDao {
  final DatabaseManager _dbManager = getIt<DatabaseManager>();
  final TaskProgressDao _taskProgressDao = TaskProgressDao();

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
    final existingToday = await db.query(
      'daily_tasks',
      columns: ['date'],
      where: 'type = ? AND date >= ? AND date < ?',
      whereArgs: [task.type, startOfDay, startOfNextDay],
      limit: 1,
    );
    final lastCompletionRows = await db.query(
      'daily_tasks',
      columns: ['date'],
      where: 'type = ? AND date < ?',
      whereArgs: [task.type, startOfDay],
      orderBy: 'date DESC',
      limit: 1,
    );
    final lastCompletion = lastCompletionRows.isNotEmpty
        ? DateTime.parse(lastCompletionRows.first['date'] as String)
        : null;
    final wasCompletedToday = existingToday.isNotEmpty;
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
    if (!wasCompletedToday) {
      await _updateTaskProgress(
        taskType: task.type,
        completionDate: normalizedDate,
        lastCompletion: lastCompletion,
      );
    }
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

  Future<void> _updateTaskProgress({
    required int taskType,
    required DateTime completionDate,
    DateTime? lastCompletion,
  }) async {
    final taskEnum = DailyTaskType.values[taskType - 1];
    final currentProgress =
        await _taskProgressDao.getTaskProgress(taskEnum) ??
            TaskProgress(
              taskType: taskEnum,
              level: 0,
              rank: 0,
              streak: 0,
              totalTasksCompleted: 0,
              tasksToNextLevel: tasksToNextLevel(0),
            );
    final updatedTotal = currentProgress.totalTasksCompleted + 1;
    final updatedLevel = calculateTaskLevel(updatedTotal);
    final updatedTasksToNext = tasksToNextLevel(updatedTotal);
    final updatedStreak = _calculateStreak(
      currentProgress.streak,
      completionDate,
      lastCompletion,
    );
    var updatedRank = currentProgress.rank;
    if (updatedLevel > currentProgress.level) {
      updatedRank = updatedLevel.clamp(0, maxTaskLevel);
    }
    if (lastCompletion != null) {
      final gap = completionDate.difference(lastCompletion).inDays;
      if (gap >= 7) {
        updatedRank = (updatedRank - 1).clamp(0, maxTaskLevel);
      }
    }
    await _taskProgressDao.upsertTaskProgress(
      currentProgress.copyWith(
        level: updatedLevel,
        rank: updatedRank,
        streak: updatedStreak,
        totalTasksCompleted: updatedTotal,
        tasksToNextLevel: updatedTasksToNext,
      ),
    );
  }

  int _calculateStreak(
      int currentStreak,
      DateTime completionDate,
      DateTime? lastCompletion,
      ) {
    if (lastCompletion == null) {
      return 1;
    }
    final difference = completionDate.difference(lastCompletion).inDays;
    if (difference == 1) {
      return currentStreak + 1;
    }
    if (difference == 0) {
      return currentStreak;
    }
    return 1;
  }
}
