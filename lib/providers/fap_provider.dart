import 'package:flutter/material.dart';
import 'package:clean_path/providers/database_provider.dart';
import '/enums/enums.dart';
import '/utils_files/timer_utils.dart';
import '/data_types/record.dart';

class FapProvider extends ChangeNotifier {
  late DatabaseProvider _databaseProvider;

  Record? fapRecord;
  int timerTime = 0;

  void update(DatabaseProvider dbProvider) {
    _databaseProvider = dbProvider;
  }

  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(AddictionTypes type) async {
    final DateTime now = DateTime.now();
    final newRecord = Record(1, type, true, now);
    fapRecord = newRecord;
    await _databaseProvider.createNewRecord(newRecord);
    notifyListeners();
  }

  Future<Record?> getRecord() async {
    fapRecord = await _databaseProvider.getActiveRecordByType(0);
    return fapRecord;
  }

  int getTimerTime() {
    if (fapRecord != null && fapRecord!.isActive) {
      final now = DateTime.now();
      return now.difference(fapRecord!.activated).inMilliseconds;
    }
    return 0;
  }

  Future<void> resetTimer() async {
    if (fapRecord != null) {
      await _databaseProvider.resetTimer(fapRecord!);
      fapRecord = null;
      timerTime = 0;
      notifyListeners();
    }
  }

  AssetImage giveWindowImage() {
    return TimerUtils.giveTimerImage(timerTime);
  }

  String getMotivationMsg() {
    return TimerUtils.giveMotivationMessage();
  }

  void showPopUp(BuildContext context) {
    TimerUtils.showMotivationPopup(context);
  }
}
