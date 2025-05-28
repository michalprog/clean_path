

import '../data_types/achievement_record.dart';

class AchievmentUtils {


  static List<AchievementRecord> getActiveRecords(List<AchievementRecord> records) {
    return records.where((r) => r.isAchieved).toList();
  }

  static List<AchievementRecord> getUnactiveRecords(List<AchievementRecord> records) {
    return records.where((r) => !r.isAchieved).toList();
  }





}