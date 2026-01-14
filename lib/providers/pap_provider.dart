import 'package:flutter/material.dart';
import '/enums/enums.dart';
import '/utils_files/timer_utils.dart';
import '/data_types/record.dart';
import '/sqlflite/record_dao.dart';

class PapProvider extends ChangeNotifier {
  final RecordDao _recordDao = RecordDao();

  Record? papRecord;
  int timerTime = 0;

  Future<void> provideData() async {
    await getRecord();
    timerTime = getTimerTime();
  }

  Future<void> createNewRecord(AddictionTypes type) async {
    final now = DateTime.now();
    final newRecord = Record(1, type, true, now);
    papRecord = newRecord;
    papRecord = await _recordDao.insert(newRecord);
    notifyListeners();
  }

  Future<Record?> getRecord() async {
    papRecord = await _recordDao.getActiveByType(1);
    return papRecord;
  }

  int getTimerTime() {
    if (papRecord != null && papRecord!.isActive) {
      return DateTime.now().difference(papRecord!.activated).inMilliseconds;
    }
    return 0;
  }

  Future<void> resetTimer() async {
    final record = papRecord;
    if (record != null) {
      papRecord = null;
      timerTime = 0;
      notifyListeners();
      final updated = record.copyWith(
        isActive: false,
        desactivated: DateTime.now(),
      );
      await _recordDao.update(updated);
    }
  }
  AssetImage giveWindowImage() => TimerUtils.giveTimerImage(timerTime);
  String getMotivationMsg() => TimerUtils.giveMotivationMessage();
  void showPopUp(BuildContext context, AddictionTypes type) {
    TimerUtils.showMotivationPopup(
      context,
      onTryAgain: () => createNewRecord(type),
    );
  }
}