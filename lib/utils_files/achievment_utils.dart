import '/data_types/achievement_record.dart';
import '/data_types/record.dart';

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

  static int totalCompletedTasks(Map<int, int> completionCounts) {
    return completionCounts.values.fold(0, (sum, value) => sum + value);
  }

  static bool hasConsecutiveDays(Set<DateTime> days, int requiredStreak) {
    if (requiredStreak <= 1) {
      return days.isNotEmpty;
    }
    if (days.length < requiredStreak) {
      return false;
    }

    final normalizedDays = days
        .map((date) => DateTime(date.year, date.month, date.day))
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    var currentStreak = 1;
    for (var i = 1; i < normalizedDays.length; i++) {
      final difference = normalizedDays[i].difference(normalizedDays[i - 1]).inDays;
      if (difference == 1) {
        currentStreak += 1;
        if (currentStreak >= requiredStreak) {
          return true;
        }
      } else {
        currentStreak = 1;
      }
    }

    return false;
  }
}