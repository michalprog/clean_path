import 'package:flutter/material.dart';
import '../data_types/record.dart';
import '../data_types/achievement_record.dart';
import '../sqlflite/achievement_dao.dart';
import '../sqlflite/record_dao.dart';

class DatabaseProvider extends ChangeNotifier {
  final RecordDao _recordDao = RecordDao();
  final AchievementDao _achievementDao = AchievementDao();


  List<Record> _records = [];
  List<Record> get records => _records;

  // === RECORDS ===

  Future<List<Record>> loadAllRecords() async {
    _records = await _recordDao.getAll();
    return _records;
  }

  Future<Record> createNewRecord(Record newRecord) async {
    final record = await _recordDao.insert(newRecord);
    await loadAllRecords(); // aktualizacja listy
    return record;
  }

  Future<Record?> getActiveRecordByType(int type) =>
      _recordDao.getActiveByType(type);

  Future<List<Record>> getRecordsByType(int type) =>
      _recordDao.getByType(type);

  Future<List<Record>> getActiveRecords() =>
      _recordDao.getAllActive();

  Future<void> resetTimer(Record record) async {
    final updated = Record(
      record.id,
      record.type,
      false,
      record.activated,
      desactivated: DateTime.now(),
    );
    await _recordDao.update(updated);
  }
  Future<void> updateRecord(Record record) async {
    await _recordDao.update(record);
  }

  // === ACHIEVEMENTS ===

  Future<List<AchievementRecord>> getAllAchievements() =>
      _achievementDao.getAll();

  Future<void> activateAchievement(int id) =>
      _achievementDao.activate(id);
}
