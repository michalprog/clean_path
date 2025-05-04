import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '../enums/enums.dart';
import '/data_types/record.dart';

class AlcocholProvider extends ChangeNotifier {
  final DatabaseProvider databaseProvider;
  AlcocholProvider(this.databaseProvider);

  Record? alcRecord;
  int timerTime = 0;
  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(addictionTypes type) async {
    final DateTime now = DateTime.now();

    final Record newRecord = Record(1, type, true, now);
    alcRecord = newRecord;
    await databaseProvider.createNewRecord(newRecord);
  }

  Future<Record?> getRecord() async {
    alcRecord = await databaseProvider.getActiveRecordByType(2);

    return alcRecord;
  }

  int getTimerTime() {
    if (alcRecord != null && alcRecord!.isActive) {
      final DateTime now = DateTime.now();
      final recordTime = alcRecord!.activated;
      return now.difference(recordTime).inMilliseconds;
    } else {
      return 0;
    }
  }

  Future<void> resetTimer() async {
    if (alcRecord != null) {
      await databaseProvider.ResetTimer(alcRecord!);
      alcRecord = null;
      timerTime = 0;
      notifyListeners();
    }
  }
}
