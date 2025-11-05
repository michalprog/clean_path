import 'package:flutter/material.dart';
import 'package:clean_path/data_types/record.dart';
import 'package:clean_path/providers/database_provider.dart';
import '/utils_files/statistic_utils.dart';
import '/enums/enums.dart';

class StatisticsProvider extends ChangeNotifier {
  late DatabaseProvider _databaseProvider;

  List<Record> allRecords = [];
  List<Record> activeRecords = [];
  List<Record> fapRecords = [];
  List<Record> papRecords = [];
  List<Record> alcRecords = [];
  List<Record> sweetRecords = [];

  void update(DatabaseProvider dbProvider) {
    _databaseProvider = dbProvider;
  }

  Future<List<Record>> getAllRecord() async {
    return await _databaseProvider.loadAllRecords();
  }

  Future<List<Record>> getActiveRecord(AddictionTypes type) async {
    return await _databaseProvider.getActiveRecords();
  }

  Future<List<Record>> getRecordByType(AddictionTypes type) async {
    return await _databaseProvider.getRecordsByType(type.index);
  }

  Future<void> provideMainData() async {
    allRecords = await getAllRecord();
    fapRecords = StatisticUtils.getRecordsByType(allRecords, AddictionTypes.fap);
    papRecords = StatisticUtils.getRecordsByType(allRecords, AddictionTypes.smoking);
    alcRecords = StatisticUtils.getRecordsByType(allRecords, AddictionTypes.alcochol);
    sweetRecords = StatisticUtils.getRecordsByType(allRecords, AddictionTypes.sweets);
  }

  Set<DateTime> getActiveDaysForType(AddictionTypes type) {
    final filtered = StatisticUtils.getRecordsByType(allRecords, type);
    return StatisticUtils.getActiveDaysFromRecords(filtered);
  }

  Set<DateTime> getFailDaysForType(AddictionTypes type) {
    final filtered = StatisticUtils.getRecordsByType(allRecords, type);
    return StatisticUtils.getFailDaysFromRecords(filtered);
  }
  Future<void> editRecordComment(Record updatedRecord) async {
    await _databaseProvider.updateRecord(updatedRecord);
    await provideMainData(); // przeładuj dane
    notifyListeners();
  }
}
