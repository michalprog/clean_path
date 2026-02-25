import '/data_types/achievement_record.dart';
import '/data_types/record.dart';
import '/data_types/user.dart';
import '/data_types/task_progress.dart';
import '/sqlflite/achievement_dao.dart';
import '/sqlflite/account_dao.dart';
import '/sqlflite/daily_login_dao.dart';
import '/sqlflite/daily_tasks_dao.dart';
import '/sqlflite/record_dao.dart';
import '/utils_files/achievment_utils.dart';

class AchievementChecker {
  final RecordDao _recordDao = RecordDao();
  final AchievementDao _achievementDao = AchievementDao();
  final DailyTasksDao _dailyTasksDao = DailyTasksDao();
  final AccountDao _accountDao = AccountDao();
  final DailyLoginDao _dailyLoginDao = DailyLoginDao();

  AchievementChecker();

  Future<List<Record>> getActiveRecords() async => _recordDao.getAllActive();

  Future<List<AchievementRecord>> getAllAchievements() async =>
      _achievementDao.getAll();

  Future<int> checkAchievements() async {
    final List<Record> activeRecords = await getActiveRecords();
    final List<AchievementRecord> allAchievements = await getAllAchievements();
    final Map<int, int> completionCounts = await _dailyTasksDao.getCompletionCounts();
    final Map<int, TaskProgress> taskProgressMap = await _dailyTasksDao.getTaskProgressMap();
    final User? user = await _accountDao.getUser();
    final Set<DateTime> loginDays = user == null
        ? <DateTime>{}
        : await _dailyLoginDao.getLoginDaysForUser(user.username);

    var activatedCount = 0;

    for (final achievement in allAchievements) {
      if (achievement.isAchieved) continue;

      switch (achievement.id) {
        case 1:
          if (activeRecords.isNotEmpty) {
            await _achievementDao.activateAchievement(1);
            activatedCount += 1;
          }
          break;

        case 2:
          if (AchievmentUtils.hasAnyRecordAtLeastMinutes(activeRecords, 60)) {
            await _achievementDao.activateAchievement(2);
            activatedCount += 1;
          }
          break;

        case 3:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 1)) {
            await _achievementDao.activateAchievement(3);
            activatedCount += 1;
          }
          break;

        case 4:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 3)) {
            await _achievementDao.activateAchievement(4);
            activatedCount += 1;
          }
          break;

        case 5:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 7)) {
            await _achievementDao.activateAchievement(5);
            activatedCount += 1;
          }
          break;

        case 6:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 14)) {
            await _achievementDao.activateAchievement(6);
            activatedCount += 1;
          }
          break;

        case 7:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 30)) {
            await _achievementDao.activateAchievement(7);
            activatedCount += 1;
          }
          break;

        case 8:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 60)) {
            await _achievementDao.activateAchievement(8);
            activatedCount += 1;
          }
          break;

        case 9:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 100)) {
            await _achievementDao.activateAchievement(9);
            activatedCount += 1;
          }
          break;

        case 10:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 200)) {
            await _achievementDao.activateAchievement(10);
            activatedCount += 1;
          }
          break;

        case 11:
          if (AchievmentUtils.hasAnyRecordAtLeastDays(activeRecords, 365)) {
            await _achievementDao.activateAchievement(11);
            activatedCount += 1;
          }
          break;

        case 12:
          if (AchievmentUtils.totalCompletedTasks(completionCounts) >= 1) {
            await _achievementDao.activateAchievement(12);
            activatedCount += 1;
          }
          break;

        case 13:
          if (await _hasAllDailyTasksCompletedInSingleDay()) {
            await _achievementDao.activateAchievement(13);
            activatedCount += 1;
          }
          break;

        case 14:
          if ((taskProgressMap[1]?.streak ?? 0) >= 7) {
            await _achievementDao.activateAchievement(14);
            activatedCount += 1;
          }
          break;

        case 15:
          if ((taskProgressMap[4]?.streak ?? 0) >= 7) {
            await _achievementDao.activateAchievement(15);
            activatedCount += 1;
          }
          break;

        case 16:
          if ((taskProgressMap[3]?.streak ?? 0) >= 7) {
            await _achievementDao.activateAchievement(16);
            activatedCount += 1;
          }
          break;

        case 17:
          if ((taskProgressMap[2]?.streak ?? 0) >= 7) {
            await _achievementDao.activateAchievement(17);
            activatedCount += 1;
          }
          break;

        case 18:
          if ((taskProgressMap[1]?.streak ?? 0) >= 30) {
            await _achievementDao.activateAchievement(18);
            activatedCount += 1;
          }
          break;

        case 19:
          if ((taskProgressMap[4]?.streak ?? 0) >= 30) {
            await _achievementDao.activateAchievement(19);
            activatedCount += 1;
          }
          break;

        case 20:
          if ((taskProgressMap[3]?.streak ?? 0) >= 30) {
            await _achievementDao.activateAchievement(20);
            activatedCount += 1;
          }
          break;

        case 21:
          if ((taskProgressMap[2]?.streak ?? 0) >= 30) {
            await _achievementDao.activateAchievement(21);
            activatedCount += 1;
          }
          break;

        case 22:
          if (AchievmentUtils.totalCompletedTasks(completionCounts) >= 5) {
            await _achievementDao.activateAchievement(22);
            activatedCount += 1;
          }
          break;

        case 23:
          if (AchievmentUtils.totalCompletedTasks(completionCounts) >= 10) {
            await _achievementDao.activateAchievement(23);
            activatedCount += 1;
          }
          break;

        case 24:
          if (AchievmentUtils.totalCompletedTasks(completionCounts) >= 50) {
            await _achievementDao.activateAchievement(24);
            activatedCount += 1;
          }
          break;

        case 25:
          if (AchievmentUtils.totalCompletedTasks(completionCounts) >= 100) {
            await _achievementDao.activateAchievement(25);
            activatedCount += 1;
          }
          break;

        case 26:
          if (AchievmentUtils.totalCompletedTasks(completionCounts) >= 200) {
            await _achievementDao.activateAchievement(26);
            activatedCount += 1;
          }
          break;

        case 27:
          if (AchievmentUtils.totalCompletedTasks(completionCounts) >= 500) {
            await _achievementDao.activateAchievement(27);
            activatedCount += 1;
          }
          break;

        case 28:
          if (AchievmentUtils.totalCompletedTasks(completionCounts) >= 1000) {
            await _achievementDao.activateAchievement(28);
            activatedCount += 1;
          }
          break;

        case 29:
          if ((user?.level ?? 0) >= 1) {
            await _achievementDao.activateAchievement(29);
            activatedCount += 1;
          }
          break;

        case 30:
          if ((user?.level ?? 0) >= 5) {
            await _achievementDao.activateAchievement(30);
            activatedCount += 1;
          }
          break;

        case 31:
          if ((user?.level ?? 0) >= 10) {
            await _achievementDao.activateAchievement(31);
            activatedCount += 1;
          }
          break;

        case 32:
          if ((user?.level ?? 0) >= 20) {
            await _achievementDao.activateAchievement(32);
            activatedCount += 1;
          }
          break;

        case 33:
          if ((user?.level ?? 0) >= 30) {
            await _achievementDao.activateAchievement(33);
            activatedCount += 1;
          }
          break;

        case 34:
          if ((user?.level ?? 0) >= 50) {
            await _achievementDao.activateAchievement(34);
            activatedCount += 1;
          }
          break;

        case 35:
          if ((user?.level ?? 0) >= 70) {
            await _achievementDao.activateAchievement(35);
            activatedCount += 1;
          }
          break;

        case 36:
          if ((user?.level ?? 0) >= 100) {
            await _achievementDao.activateAchievement(36);
            activatedCount += 1;
          }
          break;

        case 37:
          if (AchievmentUtils.hasConsecutiveDays(loginDays, 3)) {
            await _achievementDao.activateAchievement(37);
            activatedCount += 1;
          }
          break;

        case 38:
          if (AchievmentUtils.hasConsecutiveDays(loginDays, 7)) {
            await _achievementDao.activateAchievement(38);
            activatedCount += 1;
          }
          break;

        case 39:
          if (AchievmentUtils.hasConsecutiveDays(loginDays, 14)) {
            await _achievementDao.activateAchievement(39);
            activatedCount += 1;
          }
          break;

        case 40:
          if (AchievmentUtils.hasConsecutiveDays(loginDays, 30)) {
            await _achievementDao.activateAchievement(40);
            activatedCount += 1;
          }
          break;

        case 41:
          if (AchievmentUtils.hasConsecutiveDays(loginDays, 60)) {
            await _achievementDao.activateAchievement(41);
            activatedCount += 1;
          }
          break;

        case 42:
          if (AchievmentUtils.hasConsecutiveDays(loginDays, 90)) {
            await _achievementDao.activateAchievement(42);
            activatedCount += 1;
          }
          break;

        case 43:
          if (AchievmentUtils.hasConsecutiveDays(loginDays, 180)) {
            await _achievementDao.activateAchievement(43);
            activatedCount += 1;
          }
          break;

        case 44:
          if (AchievmentUtils.hasConsecutiveDays(loginDays, 365)) {
            await _achievementDao.activateAchievement(44);
            activatedCount += 1;
          }
          break;
      }
    }
    return activatedCount;
  }

  Future<bool> _hasAllDailyTasksCompletedInSingleDay() async {
    final completionCounterByDate = <DateTime, int>{};

    for (var taskType = 1; taskType <= 4; taskType++) {
      final completionDates = await _dailyTasksDao.getCompletionDatesForType(taskType);
      for (final date in completionDates) {
        final day = DateTime(date.year, date.month, date.day);
        completionCounterByDate[day] = (completionCounterByDate[day] ?? 0) + 1;
      }
    }

    return completionCounterByDate.values.any((completedTasks) => completedTasks >= 4);
  }
}