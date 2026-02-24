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

  Future<Set<DateTime>> getLoginDaysForUser(String username) async {
    final db = await _dbManager.database;
    final rows = await db.query(
      'daily_login',
      columns: ['login_date'],
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'login_date DESC',
    );

    return rows
        .map((row) => _parseDate(row['login_date'] as String?))
        .whereType<DateTime>()
        .toSet();
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parts = value.split('-');
    if (parts.length != 3) {
      return null;
    }
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) {
      return null;
    }
    return DateTime(year, month, day);
  }

  String _todayDateKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}