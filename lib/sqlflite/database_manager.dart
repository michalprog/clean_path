import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._internal();
  static Database? _database;

  DatabaseManager._internal();

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
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE record (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type INTEGER NOT NULL,
        is_active INTEGER DEFAULT 1,
        activated TEXT NOT NULL,
        desactivated TEXT
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
  }
}