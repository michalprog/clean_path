import 'package:sqflite/sqflite.dart';
import '../data_types/record.dart';
import 'database_manager.dart';

class RecordDao {
  final DatabaseManager _dbManager = DatabaseManager.instance;

  Future<Record> insert(Record record) async {
    final db = await _dbManager.database;
    final id = await db.insert('record', record.toMapForInsert());
    return record.copyWith(id: id);
  }

  Future<void> update(Record record) async {
    final db = await _dbManager.database;
    await db.update('record', record.toMap(), where: 'id = ?', whereArgs: [record.id]);
  }

  Future<Record?> getById(int id) async {
    final db = await _dbManager.database;
    final maps = await db.query('record', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Record.fromMap(maps.first) : null;
  }

  Future<List<Record>> getAll() async {
    final db = await _dbManager.database;
    final maps = await db.query('record');
    return maps.map((e) => Record.fromMap(e)).toList();
  }

  Future<List<Record>> getByType(int type) async {
    final db = await _dbManager.database;
    final maps = await db.query('record', where: 'type = ?', whereArgs: [type]);
    return maps.map((e) => Record.fromMap(e)).toList();
  }

  Future<Record?> getActiveByType(int type) async {
    final db = await _dbManager.database;
    final maps = await db.query('record', where: 'type = ? AND is_active = 1', whereArgs: [type], limit: 1);
    return maps.isNotEmpty ? Record.fromMap(maps.first) : null;
  }

  Future<List<Record>> getAllActive() async {
    final db = await _dbManager.database;
    final maps = await db.query('record', where: 'is_active = 1');
    return maps.map((e) => Record.fromMap(e)).toList();
  }
}
