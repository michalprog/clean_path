import '/data_types/record.dart';
import '/data_types/achievement_record.dart';

class AchievmentUtils {


  static List<AchievementRecord> getActiveRecords(List<AchievementRecord> records) {
    return records.where((r) => r.isAchieved).toList();
  }

  static List<AchievementRecord> getUnactiveRecords(List<AchievementRecord> records) {
    return records.where((r) => !r.isAchieved).toList();
  }

  static bool hasAnyRecordAtLeastDays(List<Record> records, int days) {
    final now = DateTime.now();
    return records.any((r) => now.difference(r.activated).inDays >= days);
  }

  static bool hasAnyRecordAtLeastMinutes(List<Record> records, int minutes) {
    final now = DateTime.now();
    return records.any((r) => now.difference(r.activated).inMinutes >= minutes);
  }




}