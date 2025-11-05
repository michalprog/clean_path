import '/data_types/achievement_record.dart';
import '/data_types/record.dart';
import '/providers/database_provider.dart';
import '/utils_files/achievment_utils.dart';

class AchievementChecker {
  final DatabaseProvider databaseProvider;

  AchievementChecker(this.databaseProvider);

  Future<List<Record>> getActiveRecords() async {
    final activeRecords = await databaseProvider.getActiveRecords();
    return activeRecords;
  }
  Future<List<AchievementRecord>> getAllAchievements() async {
    final achievements = await databaseProvider.getAllAchievements();
    return achievements;
  }
  Future<void> checkAchievements() async {
    final List<Record> activeRecords = await getActiveRecords();
    final List<AchievementRecord> allAchievements = await getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.isAchieved) continue;

      switch (achievement.id) {
        case 1:
        // "zaczynamy!" – wystarczy jeden aktywny rekord
          if (activeRecords.isNotEmpty) {
            await databaseProvider.activateAchievement(1);
          }
          break;

        case 2:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 1)) {
            await databaseProvider.activateAchievement(2);
          }
          break;

        case 3:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 3)) {
            await databaseProvider.activateAchievement(3);
          }
          break;

        case 4:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 7)) {
            await databaseProvider.activateAchievement(4);
          }
          break;

        case 5:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 14)) {
            await databaseProvider.activateAchievement(5);
          }
          break;

        case 6:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 30)) {
            await databaseProvider.activateAchievement(6);
          }
          break;

        case 7:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 60)) {
            await databaseProvider.activateAchievement(7);
          }
          break;

        case 8:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 100)) {
            await databaseProvider.activateAchievement(8);
          }
          break;

        case 9:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 365)) {
            await databaseProvider.activateAchievement(9);
          }
          break;

        case 10:
          if (AchievmentUtils.hasAnyRecordAtLeastMinutes(activeRecords, 1)) {
            await databaseProvider.activateAchievement(10);
          }
          break;
      }
    }
  }




}