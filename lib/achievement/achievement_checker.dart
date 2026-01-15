import '/data_types/achievement_record.dart';
import '/data_types/record.dart';
import '/sqlflite/achievement_dao.dart';
import '/sqlflite/record_dao.dart';
import '/utils_files/achievment_utils.dart';

class AchievementChecker {
  final RecordDao _recordDao = RecordDao();
  final AchievementDao _achievementDao = AchievementDao();

  AchievementChecker();

  Future<List<Record>> getActiveRecords() async => _recordDao.getAllActive();

  Future<List<AchievementRecord>> getAllAchievements() async =>
      _achievementDao.getAll();

  Future<void> checkAchievements() async {
    final List<Record> activeRecords = await getActiveRecords();
    final List<AchievementRecord> allAchievements = await getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.isAchieved) continue;

      switch (achievement.id) {
        case 1:
          if (activeRecords.isNotEmpty) {
            await _achievementDao.activateAchievement(1);
          }
          break;

        case 2:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 1)) {
            await _achievementDao.activateAchievement(2);
          }
          break;

        case 3:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 3)) {
            await _achievementDao.activateAchievement(3);
          }
          break;

        case 4:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 7)) {
            await _achievementDao.activateAchievement(4);
          }
          break;

        case 5:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 14)) {
            await _achievementDao.activateAchievement(5);
          }
          break;

        case 6:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 30)) {
            await _achievementDao.activateAchievement(6);
          }
          break;

        case 7:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 60)) {
            await _achievementDao.activateAchievement(7);
          }
          break;

        case 8:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 100)) {
            await _achievementDao.activateAchievement(8);
          }
          break;

        case 9:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 365)) {
            await _achievementDao.activateAchievement(9);
          }
          break;

        case 10:
          if (AchievmentUtils.hasAnyRecordAtLeastMinutes(activeRecords, 1)) {
            await _achievementDao.activateAchievement(10);
          }
          break;
      }
    }
  }
}