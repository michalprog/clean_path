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
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

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
    date TEXT NOT NULL
    )
    ''');
  }
}
