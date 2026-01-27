import 'package:sqflite/sqflite.dart';

import '/data_types/task_progress.dart';
import '/enums/enums.dart';
import '/main/service_locator.dart';
import 'database_manager.dart';

class TaskProgressDao {
  final DatabaseManager _dbManager = getIt<DatabaseManager>();

  Future<TaskProgress?> getTaskProgress(DailyTaskType taskType) async {
    final db = await _dbManager.database;
    final rows = await db.query(
      'task_progress',
      where: 'id = ?',
      whereArgs: [taskType.index + 1],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return TaskProgress.fromMap(rows.first);
  }

  Future<void> upsertTaskProgress(TaskProgress progress) async {
    final db = await _dbManager.database;
    await db.insert(
      'task_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}