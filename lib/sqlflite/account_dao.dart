import 'package:sqflite/sqflite.dart';

import '/data_types/user.dart';
import '/main/service_locator.dart';
import 'database_manager.dart';

class AccountDao {
  final DatabaseManager _dbManager = getIt<DatabaseManager>();

  Future<User?> getUser() async {
    final db = await _dbManager.database;
    final maps = await db.query('user', limit: 1);
    if (maps.isEmpty) {
      return null;
    }

    return User.fromMap(maps.first);
  }

  Future<void> upsertUser(User user, {String? previousUsername}) async {
    final db = await _dbManager.database;
    final usernameForUpdate = previousUsername ?? user.username;
    final updated = await db.update(
      'user',
      user.toMap(),
      where: 'username = ?',
      whereArgs: [usernameForUpdate],
    );

    if (updated == 0) {
      await db.insert(
        'user',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}