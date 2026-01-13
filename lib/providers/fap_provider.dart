import 'package:flutter/material.dart';
import '/enums/enums.dart';
import '/utils_files/timer_utils.dart';
import '/data_types/record.dart';
import '/sqlflite/record_dao.dart';

class FapProvider extends ChangeNotifier {
  final RecordDao _recordDao = RecordDao();

  Record? fapRecord;
  int timerTime = 0;

  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(AddictionTypes type) async {
    final DateTime now = DateTime.now();
    final newRecord = Record(1, type, true, now);
    fapRecord = newRecord;
    fapRecord = await _recordDao.insert(newRecord);
    notifyListeners();
  }

  Future<Record?> getRecord() async {
    fapRecord = await _recordDao.getActiveByType(0);
    return fapRecord;
  }

  int getTimerTime() {
    if (fapRecord != null && fapRecord!.isActive) {
      final now = DateTime.now();
      return now
          .difference(fapRecord!.activated)
          .inMilliseconds;
    }
    return 0;
  }

  Future<void> resetTimer() async {
    if (fapRecord != null) {
      final updated = fapRecord!.copyWith(
        isActive: false,
        desactivated: DateTime.now(),
      );
      await _recordDao.update(updated);
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

  void showPopUp(BuildContext context, {required VoidCallback onTryAgain}) {
    TimerUtils.showMotivationPopup(context, onTryAgain: onTryAgain);
  }
}
