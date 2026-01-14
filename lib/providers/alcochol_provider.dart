import 'package:flutter/material.dart';
import '/enums/enums.dart';
import '/utils_files/timer_utils.dart';
import '/data_types/record.dart';
import '/sqlflite/record_dao.dart';

class AlcocholProvider extends ChangeNotifier {
  final RecordDao _recordDao = RecordDao();

  Record? alcRecord;
  int timerTime = 0;

  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(AddictionTypes type) async {
    final now = DateTime.now();
    final newRecord = Record(1, type, true, now);
    alcRecord = newRecord;
    alcRecord = await _recordDao.insert(newRecord);
    notifyListeners();
  }

  Future<Record?> getRecord() async {
    alcRecord = await _recordDao.getActiveByType(2);
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
    final record = alcRecord;
    if (record != null) {
      alcRecord = null;
      timerTime = 0;
      notifyListeners();
      final updated = record.copyWith(
        isActive: false,
        desactivated: DateTime.now(),
      );
      await _recordDao.update(updated);
    }
  }

  AssetImage giveWindowImage() {
    return TimerUtils.giveTimerImage(timerTime);
  }

  String getMotivationMsg() {
    return TimerUtils.giveMotivationMessage();
  }

  void showPopUp(BuildContext context, AddictionTypes type) {
    TimerUtils.showMotivationPopup(
      context,
      onTryAgain: () => createNewRecord(type),
    );
  }
}
