import 'package:clean_path/data_types/record.dart';
import 'package:flutter/material.dart';
import '../utils_files/statistic_utils.dart';
import '/enums/enums.dart';
import 'database_provider.dart';

class StatisticsProvider extends ChangeNotifier
{
  final DatabaseProvider databaseProvider;

  StatisticsProvider(this.databaseProvider);

  List<Record> allRecords=[];
  List<Record> activeRecords=[];
  List<Record> fapRecords=[];
  List<Record> papRecords=[];
  List<Record> alcRecords=[];
  List<Record> sweetRecords=[];

  get allRecorods => allRecords;



  Future<List<Record>> getAllRecord()
  async{
    return await databaseProvider.loadAllRecords();

  }
  Future <List<Record>> getActiveRecord(AddictionTypes type)
  async{
    return await databaseProvider.getActiveRecords();
  }
  Future <List<Record>> getRecordByType(AddictionTypes type)
  async{
    return await databaseProvider.getRecordsByType(type.index);
  }
Future <void> provideMainData()
async {
  allRecords=await getAllRecord();
  fapRecords=StatisticUtils.getRecordsByType(allRecords, AddictionTypes.fap);
  papRecords=StatisticUtils.getRecordsByType(allRecords, AddictionTypes.smoking);
  alcRecords=StatisticUtils.getRecordsByType(allRecords, AddictionTypes.alcochol);
  sweetRecords=StatisticUtils.getRecordsByType(allRecords, AddictionTypes.sweets);

}











}