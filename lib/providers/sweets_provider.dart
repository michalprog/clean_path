import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '../enums/enums.dart';
import '/data_types/record.dart';


class SweetsProvider  extends ChangeNotifier{

  final DatabaseProvider databaseProvider;
  SweetsProvider(this.databaseProvider);


  Record? sweetRecord;
  int timerTime=0;
  Future<void>provideData()
  async {
    await getRecord();
    timerTime=getTimerTime();

  }

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
    sweetRecord=newRecord;
    await databaseProvider.createNewRecord(newRecord);
  }
  Future<Record?> getRecord()
  async {
    sweetRecord= await databaseProvider.getActiveRecordByType(3);

    return sweetRecord;
  }
  int getTimerTime()
  {
    if (sweetRecord != null && sweetRecord!.isActive)
    {
      final DateTime now = DateTime.now();
      final recordTime = sweetRecord!.activated;
      return now.difference(recordTime).inMilliseconds;
    }else
    {
      return 0;
    }

  }
  Future<void> resetTimer()async {
    if (sweetRecord != null) {
      await databaseProvider.ResetTimer(sweetRecord!);
      sweetRecord = null;
      timerTime = 0;
      notifyListeners();
    }
  }
}