import 'package:clean_path/data_types/record.dart';
import 'package:flutter/material.dart';
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

  Future<List<Record>> getAllRecord()
  async{
    return await databaseProvider.loadAllRecords();

  }
  Future <List<Record>> getActiveRecord(addictionTypes type)
  async{
    return await databaseProvider.getActiveRecords();
  }
  Future <List<Record>> getRecordByType(addictionTypes type)
  async{
    return await databaseProvider.getRecordsByType(type.index);
  }












}