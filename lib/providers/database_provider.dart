import 'package:flutter/material.dart';
import '../enums/enums.dart';
import '../sqlflite/sql_class.dart';
import '/data_types/record.dart';

class DatabaseProvider extends ChangeNotifier {
  final SqlClass _sqlClass = SqlClass.instance;

  List<Record> _records = [];
  List<Record> get records => _records;

  Future<void> loadAllRecords() async {
    _records = await _sqlClass.getAllRecords();
    notifyListeners();
  }

  Future<Record> createNewRecord(Record newRecord) async {
    Record record = await _sqlClass.insertRecord(newRecord);
    // Odświeżamy listę rekordów
    await loadAllRecords();
    return record;
  }

  Future<Record?> getActiveRecordByType(int type) async {
    return await _sqlClass.getActiveRecordByType(type);
  }

  Future<void> ResetTimer(Record record) async {
    Record updatedRecord = Record(
      record.id,
      record.type,
      false,
      record.activated,
      desactivated: DateTime.now(),
    );
    await _sqlClass.updateRecord(updatedRecord);
  }
}
