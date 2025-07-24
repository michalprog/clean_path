import 'package:flutter/material.dart';
import 'package:clean_path/providers/database_provider.dart';
import '/enums/enums.dart';
import '/utils_files/timer_utils.dart';
import '/data_types/record.dart';

class SweetsProvider extends ChangeNotifier {
  late DatabaseProvider _databaseProvider;

  Record? sweetRecord;
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
    sweetRecord = newRecord;
    await _databaseProvider.createNewRecord(newRecord);
  }

  Future<Record?> getRecord() async {
    sweetRecord = await _databaseProvider.getActiveRecordByType(3);
    return sweetRecord;
  }

  int getTimerTime() {
    if (sweetRecord != null && sweetRecord!.isActive) {
      return DateTime.now().difference(sweetRecord!.activated).inMilliseconds;
    }
    return 0;
  }

  Future<void> resetTimer() async {
    if (sweetRecord != null) {
      await _databaseProvider.resetTimer(sweetRecord!);
      sweetRecord = null;
      timerTime = 0;
      notifyListeners();
    }
  }

  AssetImage giveWindowImage() => TimerUtils.giveTimerImage(timerTime);
  String getMotivationMsg() => TimerUtils.giveMotivationMessage();
  void showPopUp(BuildContext context) => TimerUtils.showMotivationPopup(context);
}
