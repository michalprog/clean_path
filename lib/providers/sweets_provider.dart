import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '../enums/enums.dart';
import '/data_types/record.dart';


class SweetsProvider  extends ChangeNotifier{

  final DatabaseProvider databaseProvider;
  SweetsProvider(this.databaseProvider);
  Future<void> createNewRecord(addictionTypes type) async {
    // Tworzymy aktualną datę
    final DateTime now = DateTime.now();

    // Tworzymy nowy rekord - id=0 zostanie zastąpione przez autoinkrementację w bazie
    final Record newRecord = Record(
      1,
      type,
      true, // rekord jest aktywny
      now, // przechowujemy DateTime


    );
    await databaseProvider.createNewRecord(newRecord);
  }
  Future<Record?> getRecord()
  async {
    return databaseProvider.getActiveRecordByType(1);
    return null;
  }

}