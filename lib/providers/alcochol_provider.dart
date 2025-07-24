import 'package:flutter/material.dart';
import 'package:clean_path/providers/database_provider.dart';
import '/enums/enums.dart';
import '/utils_files/timer_utils.dart';
import '/data_types/record.dart';

class AlcocholProvider extends ChangeNotifier {
  late DatabaseProvider _databaseProvider;

  Record? alcRecord;
  int timerTime = 0;

  void update(DatabaseProvider dbProvider) {
    _databaseProvider = dbProvider;
  }

  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(AddictionTypes type) async {
    final now = DateTime.now();
    final newRecord = Record(1, type, true, now);
    alcRecord = newRecord;
    await _databaseProvider.createNewRecord(newRecord);
    notifyListeners();
  }

  Future<Record?> getRecord() async {
    alcRecord = await _databaseProvider.getActiveRecordByType(2);
    return alcRecord;
  }

  int getTimerTime() {
    if (alcRecord != null && alcRecord!.isActive) {
      final now = DateTime.now();
      return now.difference(alcRecord!.activated).inMilliseconds;
    }
    return 0;
  }

  Future<void> resetTimer() async {
    if (alcRecord != null) {
      await _databaseProvider.resetTimer(alcRecord!);
      alcRecord = null;
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
