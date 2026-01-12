import 'package:sqflite/sqflite.dart';
import '/data_types/daily_task.dart';
import '/main/service_locator.dart';
import 'database_manager.dart';

class DailyTasksDao {
  final DatabaseManager _dbManager = getIt<DatabaseManager>();

  static const List<String> _defaultTasks = [
    'Daily task 1',
    'Daily task 2',
    'Daily task 3',
    'Daily task 4',
  ];

  Future<void> ensureInitialized() async {
    final db = await _dbManager.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS daily_task (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        last_completed TEXT
      )
    ''');

    final existing = await db.query('daily_task');
    if (existing.isEmpty) {
      for (final title in _defaultTasks) {
        await db.insert(
          'daily_task',
          {'title': title},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<List<DailyTask>> getAll() async {
    final db = await _dbManager.database;
    final maps = await db.query('daily_task');
    return maps.map(DailyTask.fromMap).toList();
  }

  Future<DailyTask> insert(DailyTask task) async {
    final db = await _dbManager.database;
    final id = await db.insert('daily_task', task.toMap());
    return task.copyWith(id: id);
  }

  Future<void> update(DailyTask task) async {
    final db = await _dbManager.database;
    await db.update(
      'daily_task',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}