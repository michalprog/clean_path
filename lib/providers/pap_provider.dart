import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '/enums/enums.dart';

import '/utils_files/timer_utils.dart';
import '/data_types/record.dart';

class PapProvider extends ChangeNotifier {
  Record? papRecord;
  int timerTime = 0;
  final DatabaseProvider databaseProvider;
  PapProvider(this.databaseProvider);
  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(AddictionTypes type) async {
    final DateTime now = DateTime.now();

    final Record newRecord = Record(1, type, true, now);
    papRecord = newRecord;
    await databaseProvider.createNewRecord(newRecord);
  }

  Future<Record?> getRecord() async {
    papRecord = await databaseProvider.getActiveRecordByType(1);

    return papRecord;
  }

  int getTimerTime() {
    if (papRecord != null && papRecord!.isActive) {
      final DateTime now = DateTime.now();
      final recordTime = papRecord!.activated;
      return now.difference(recordTime).inMilliseconds;
    } else {
      return 0;
    }
  }

  Future<void> resetTimer() async {
    if (papRecord != null) {
      await databaseProvider.ResetTimer(papRecord!);
      papRecord = null;
      timerTime = 0;
      notifyListeners();
    }
  }
  AssetImage giveWindowImage()
  {
    return TimerUtils.giveTimerImage(timerTime);
  }
  String getMotivationMsg()
  {
    return TimerUtils.giveMotivationMessage();
  }
  void showPopUp(BuildContext context)
  {
    TimerUtils.showMotivationPopup(context);
  }
}
