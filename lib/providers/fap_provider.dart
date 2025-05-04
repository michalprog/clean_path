import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '../enums/enums.dart';

import '/data_types/record.dart';

class FapProvider extends ChangeNotifier {
  final DatabaseProvider databaseProvider;
  FapProvider(this.databaseProvider);
  Record? fapRecord;
  int timerTime = 0;
  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(addictionTypes type) async {
    final DateTime now = DateTime.now();

    final Record newRecord = Record(1, type, true, now);
    fapRecord = newRecord;
    await databaseProvider.createNewRecord(newRecord);
  }

  Future<Record?> getRecord() async {
    fapRecord = await databaseProvider.getActiveRecordByType(0);

    return fapRecord;
  }

  int getTimerTime() {
    if (fapRecord != null && fapRecord!.isActive) {
      final DateTime now = DateTime.now();
      final recordTime = fapRecord!.activated;
      return now.difference(recordTime).inMilliseconds;
    } else {
      return 0;
    }
  }

  Future<void> resetTimer() async {
    if (fapRecord != null) {
      await databaseProvider.ResetTimer(fapRecord!);
      fapRecord = null;
      timerTime = 0;
      notifyListeners();
    }
  }
}
