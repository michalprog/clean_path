import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
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

    return await openDatabase(
      path,
      version: 8,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: _ensureDefaultUser,
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
      CREATE TABLE user (
        username TEXT PRIMARY KEY,
        password TEXT,
        email TEXT,
        xp INTEGER NOT NULL,
        level INTEGER NOT NULL,
        character INTEGER NOT NULL,
         streak INTEGER NOT NULL DEFAULT 0,
        join_date TEXT NOT NULL,
        status INTEGER NOT NULL
      )
    ''');

    await _ensureDefaultUser(db);
  }


  // UPGRADE

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
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

    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user (
          username TEXT PRIMARY KEY,
          password TEXT,
          email TEXT,
          xp INTEGER NOT NULL,
          level INTEGER NOT NULL
        )
      ''');
    }

    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE user_new (
          username TEXT PRIMARY KEY,
          password TEXT,
          email TEXT,
          xp INTEGER NOT NULL,
          level INTEGER NOT NULL,
          character INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        INSERT INTO user_new (username, password, email, xp, level, character)
        SELECT username, password, email, xp, level, 0 FROM user
      ''');

      await db.execute('DROP TABLE user');
      await db.execute('ALTER TABLE user_new RENAME TO user');
    }

    if (oldVersion < 6) {
      if (!await _hasColumn(db, 'user', 'character')) {
        await db.execute(
          'ALTER TABLE user ADD COLUMN character INTEGER NOT NULL DEFAULT 0',
        );
      }
    }

    if (oldVersion < 7) {
      if (!await _hasColumn(db, 'user', 'join_date')) {
        await db.execute(
          "ALTER TABLE user ADD COLUMN join_date TEXT NOT NULL DEFAULT ''",
        );
      }
    }

    if (oldVersion < 8) {
      if (!await _hasColumn(db, 'user', 'streak')) {
        await db.execute(
          'ALTER TABLE user ADD COLUMN streak INTEGER NOT NULL DEFAULT 0',
        );
      }
    }

    if (!await _hasColumn(db, 'user', 'status')) {
      await db.execute(
        'ALTER TABLE user ADD COLUMN status INTEGER NOT NULL DEFAULT 1',
      );
    }

    await _ensureDefaultUser(db);
  }


  // HELPERS

  Future<void> _ensureDefaultUser(Database db) async {
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM user');
    final count = Sqflite.firstIntValue(result) ?? 0;

    if (count == 0) {
      await db.insert('user', {
        'username': 'user',
        'password': null,
        'email': null,
        'xp': 0,
        'level': 0,
        'character': 0,
        'streak': 0,
        'join_date': DateTime.now().toIso8601String(),
        'status': 0,
      });
    }
  }

  Future<bool> _hasColumn(Database db, String table, String column) async {
    final result = await db.rawQuery('PRAGMA table_info($table)');
    return result.any((row) => row['name'] == column);
  }
}
