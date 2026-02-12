import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/enums/enums.dart';
import '/utils_files/task_progress_utils.dart';

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
      version: 11,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await _ensureDefaultUser(db);
        await _ensureDefaultTaskProgress(db);
        await _ensureDefaultTaskLevels(db);
        await _ensureDefaultTaskRanks(db);
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
        rank INTEGER NOT NULL,
        streak INTEGER NOT NULL,
        total_tasks_completed INTEGER NOT NULL,
        tasks_to_next_level INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE task_levels (
        level INTEGER PRIMARY KEY,
        min_tasks INTEGER NOT NULL,
        max_tasks INTEGER NOT NULL,
        color TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE task_ranks (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        min_level INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE daily_login (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        login_date TEXT NOT NULL,
        UNIQUE(username, login_date),
        FOREIGN KEY(username) REFERENCES user(username)
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_daily_login_username_date
      ON daily_login(username, login_date)
    ''');


    await _ensureDefaultUser(db);
    await _ensureDefaultTaskProgress(db);
    await _ensureDefaultTaskLevels(db);
    await _ensureDefaultTaskRanks(db);
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

    if (oldVersion < 9) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS task_progress (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          level INTEGER NOT NULL,
          rank INTEGER NOT NULL,
          streak INTEGER NOT NULL,
          total_tasks_completed INTEGER NOT NULL,
          tasks_to_next_level INTEGER NOT NULL
        )
      ''');
    }

    if (!await _hasColumn(db, 'task_progress', 'rank')) {
      await db.execute(
        'ALTER TABLE task_progress ADD COLUMN rank INTEGER NOT NULL DEFAULT 0',
      );
    }

    // v10: task_levels + task_ranks
    if (oldVersion < 10) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS task_levels (
          level INTEGER PRIMARY KEY,
          min_tasks INTEGER NOT NULL,
          max_tasks INTEGER NOT NULL,
          color TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS task_ranks (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          min_level INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 11) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_login (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          login_date TEXT NOT NULL,
          UNIQUE(username, login_date),
          FOREIGN KEY(username) REFERENCES user(username)
        )
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_daily_login_username_date
        ON daily_login(username, login_date)
      ''');

      final hasLegacyTable = await _tableExists(db, 'user_login_days');
      if (hasLegacyTable) {
        await db.execute('''
          INSERT OR IGNORE INTO daily_login (username, login_date)
          SELECT username, login_date FROM user_login_days
        ''');
        await db.execute('DROP TABLE IF EXISTS user_login_days');
      }
    }
    await _ensureDefaultUser(db);
    await _ensureDefaultTaskProgress(db);
    await _ensureDefaultTaskLevels(db);
    await _ensureDefaultTaskRanks(db);
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
        'rank': 0,
        'streak': 0,
        'total_tasks_completed': 0,
        'tasks_to_next_level': tasksToNextLevel(0),
      });
    }
  }

  Future<void> _ensureDefaultTaskLevels(Database db) async {
    final hasTaskLevels = await _tableExists(db, 'task_levels');
    if (!hasTaskLevels) return;

    final result = await db.rawQuery('SELECT COUNT(*) as count FROM task_levels');
    final count = Sqflite.firstIntValue(result) ?? 0;
    if (count != 0) return;

    for (var level = 0; level <= maxTaskLevel; level++) {
      await db.insert('task_levels', {
        'level': level,
        'min_tasks': minTasksForLevel(level),
        'max_tasks': maxTasksForLevel(level),
        'color': taskLevelColors[level],
      });
    }
  }

  Future<void> _ensureDefaultTaskRanks(Database db) async {
    final hasTaskRanks = await _tableExists(db, 'task_ranks');
    if (!hasTaskRanks) return;

    final result = await db.rawQuery('SELECT COUNT(*) as count FROM task_ranks');
    final count = Sqflite.firstIntValue(result) ?? 0;
    if (count != 0) return;

    for (var rank = 0; rank <= maxTaskLevel; rank++) {
      await db.insert('task_ranks', {
        'id': rank,
        'title': taskRankTitles[rank],
        'min_level': rank,
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