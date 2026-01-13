import 'package:flutter/material.dart';
import '/enums/enums.dart';
import '/utils_files/timer_utils.dart';
import '/data_types/record.dart';
import '/sqlflite/record_dao.dart';

class SweetsProvider extends ChangeNotifier {
  final RecordDao _recordDao = RecordDao();

  Record? sweetRecord;
  int timerTime = 0;

  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(AddictionTypes type) async {
    final now = DateTime.now();
    final newRecord = Record(1, type, true, now);
    sweetRecord = newRecord;
    sweetRecord = await _recordDao.insert(newRecord);
  }

  Future<Record?> getRecord() async {
    sweetRecord = await _recordDao.getActiveByType(3);
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
      final updated = sweetRecord!.copyWith(
        isActive: false,
        desactivated: DateTime.now(),
      );
      await _recordDao.update(updated);
      sweetRecord = null;
      timerTime = 0;
      notifyListeners();
    }
  }

  AssetImage giveWindowImage() => TimerUtils.giveTimerImage(timerTime);
  String getMotivationMsg() => TimerUtils.giveMotivationMessage();
  void showPopUp(BuildContext context, {required VoidCallback onTryAgain}) {
    TimerUtils.showMotivationPopup(context, onTryAgain: onTryAgain);
  }
}