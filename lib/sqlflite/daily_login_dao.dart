import 'package:sqflite/sqflite.dart';

import '/main/service_locator.dart';
import 'database_manager.dart';

class DailyLoginDao {
  final DatabaseManager _dbManager = getIt<DatabaseManager>();

  Future<bool> ensureTodayLoginSaved(String username) async {
    final db = await _dbManager.database;
    final today = _todayDateKey();

    final existing = await db.query(
      'daily_login',
      columns: ['id'],
      where: 'username = ? AND login_date = ?',
      whereArgs: [username, today],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      return false;
    }

    final insertedId = await db.insert(
      'daily_login',
      {
        'username': username,
        'login_date': today,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    return insertedId > 0;
  }

  String _todayDateKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}