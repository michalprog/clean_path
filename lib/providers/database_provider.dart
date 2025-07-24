import 'package:flutter/material.dart';
import '../data_types/achievement_record.dart';
import '../sqlflite/sql_class.dart';
import '/data_types/record.dart';

class DatabaseProvider extends ChangeNotifier {
  final SqlClass _sqlClass = SqlClass.instance;

  List<Record> _records = [];
  List<Record> get records => _records;

  Future<List<Record>> loadAllRecords() async {
    _records = await _sqlClass.getAllRecords();
    return _records;
  }

  Future<Record> createNewRecord(Record newRecord) async {
    final record = await _sqlClass.insertRecord(newRecord);
    await loadAllRecords(); // aktualizacja listy
    return record;
  }

  Future<Record?> getActiveRecordByType(int type) =>
      _sqlClass.getActiveRecordByType(type);

  Future<List<Record>> getRecordsByType(int type) =>
      _sqlClass.getRecordsByType(type);

  Future<List<Record>> getActiveRecords() => _sqlClass.getActiveRecords();

  Future<void> resetTimer(Record record) async {
    final updated = Record(
      record.id,
      record.type,
      false,
      record.activated,
      desactivated: DateTime.now(),
    );
    await _sqlClass.updateRecord(updated);
  }

  Future<List<AchievementRecord>> getAllAchievements() =>
      _sqlClass.getAllAchievements();

  Future<void> activateAchievement(int id) =>
      _sqlClass.activateAchievement(id);
}
