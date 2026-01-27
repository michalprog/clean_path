import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/enums/enums.dart';

class DatabaseManager {
  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return openDatabase(
      path,
      version: 9,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await _ensureDefaultUser(db);
        await _ensureDefaultTaskProgress(db);
      },
    );
  }

  // CREATE

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE record (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type INTEGER NOT NULL,
        is_active INTEGER DEFAULT 1,
        activated TEXT NOT NULL,
        desactivated TEXT,
        comment TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE achievement_record (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        is_achieved INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        achievement_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type INTEGER NOT NULL,
        date TEXT NOT NULL,
        UNIQUE(type, date)
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_daily_tasks_date
      ON daily_tasks(date)
    ''');

    // docelowy schemat user (v9)
    await db.execute('''
      CREATE TABLE user (
        username TEXT PRIMARY KEY,
        password TEXT,
        email TEXT,
        xp INTEGER NOT NULL,
        level INTEGER NOT NULL,
        character INTEGER NOT NULL,
        streak INTEGER NOT NULL DEFAULT 0,
        join_date TEXT NOT NULL,
        last_seen TEXT NOT NULL,
        status INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE task_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        level INTEGER NOT NULL,
        streak INTEGER NOT NULL,
        total_tasks_completed INTEGER NOT NULL,
        tasks_to_next_level INTEGER NOT NULL
      )
    ''');

    await _ensureDefaultUser(db);
    await _ensureDefaultTaskProgress(db);
  }

  // UPGRADE

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // v3: daily_tasks + index
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type INTEGER NOT NULL,
          date TEXT NOT NULL,
          UNIQUE(type, date)
        )
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_daily_tasks_date
        ON daily_tasks(date)
      ''');
    }

    // v4: user table (jeśli wcześniej nie istniała)
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user (
          username TEXT PRIMARY KEY,
          password TEXT,
          email TEXT,
          xp INTEGER NOT NULL DEFAULT 0,
          level INTEGER NOT NULL DEFAULT 0
        )
      ''');
    }

    // v5: last_seen + status (albo pojawiły się później — robimy idempotentnie)
    // v6: character
    if (!await _hasColumn(db, 'user', 'character')) {
      await db.execute(
        'ALTER TABLE user ADD COLUMN character INTEGER NOT NULL DEFAULT 0',
      );
    }

    // v7: join_date
    if (!await _hasColumn(db, 'user', 'join_date')) {
      await db.execute(
        "ALTER TABLE user ADD COLUMN join_date TEXT NOT NULL DEFAULT ''",
      );
    }

    // v8: streak
    if (!await _hasColumn(db, 'user', 'streak')) {
      await db.execute(
        'ALTER TABLE user ADD COLUMN streak INTEGER NOT NULL DEFAULT 0',
      );
    }

    // last_seen
    if (!await _hasColumn(db, 'user', 'last_seen')) {
      await db.execute(
        "ALTER TABLE user ADD COLUMN last_seen TEXT NOT NULL DEFAULT ''",
      );
    }

    // status
    if (!await _hasColumn(db, 'user', 'status')) {
      await db.execute(
        'ALTER TABLE user ADD COLUMN status INTEGER NOT NULL DEFAULT 1',
      );
    }

    // v9: task_progress
    if (oldVersion < 9) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS task_progress (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          level INTEGER NOT NULL,
          streak INTEGER NOT NULL,
          total_tasks_completed INTEGER NOT NULL,
          tasks_to_next_level INTEGER NOT NULL
        )
      ''');
    }

    await _ensureDefaultUser(db);
    await _ensureDefaultTaskProgress(db);
  }

  // HELPERS

  Future<void> _ensureDefaultUser(Database db) async {
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM user');
    final count = Sqflite.firstIntValue(result) ?? 0;

    if (count != 0) return;

    final now = DateTime.now().toIso8601String();

    // Wstawiamy zgodnie z docelowym schematem v9:
    await db.insert('user', {
      'username': 'user',
      'password': null,
      'email': null,
      'xp': 0,
      'level': 0,
      'character': 0,
      'streak': 0,
      'join_date': now,
      'last_seen': now,
      'status': 0,
    });
  }

  Future<void> _ensureDefaultTaskProgress(Database db) async {
    // Jeśli tabela jeszcze nie istnieje (stara wersja), nie wywalaj aplikacji
    final hasTaskProgress = await _tableExists(db, 'task_progress');
    if (!hasTaskProgress) return;

    for (final taskType in DailyTaskType.values) {
      final id = taskType.index + 1;

      final existing = await db.query(
        'task_progress',
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (existing.isNotEmpty) continue;

      await db.insert('task_progress', {
        'id': id,
        'level': 0,
        'streak': 0,
        'total_tasks_completed': 0,
        'tasks_to_next_level': 0,
      });
    }
  }

  Future<bool> _hasColumn(Database db, String table, String column) async {
    final result = await db.rawQuery('PRAGMA table_info($table)');
    return result.any((row) => row['name'] == column);
  }

  Future<bool> _tableExists(Database db, String table) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [table],
    );
    return result.isNotEmpty;
  }
}
