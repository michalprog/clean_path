import 'package:flutter/material.dart';
import '/achievement/achievement_checker.dart';
import '/data_types/achievement_record.dart';
import '/utils_files/achievment_utils.dart';
import '/sqlflite/achievement_dao.dart';

class AchievementProvider extends ChangeNotifier {
  final AchievementDao _achievementDao = AchievementDao();
  final AchievementChecker _achievementChecker = AchievementChecker();

  List<AchievementRecord> _achievements = [];
  List<AchievementRecord> activeAchievements = [];
  List<AchievementRecord> unsactiveAchievements = [];
  List<AchievementRecord> showAchievements = [];

  List<AchievementRecord> get achievements => _achievements;

  Future<void> fetchAchievements() async {
    _achievements = await _achievementDao.getAll();
    notifyListeners();
  }

  Future<void> activateAchievement(int id) async {
    await _achievementDao.activateAchievement(id);
    await fetchAchievements();
  }

  Future<void> statisticInicjalization() async {
    await checkAchievements();
    await fetchAchievements();
    activeAchievements = AchievmentUtils.getActiveRecords(_achievements);
    unsactiveAchievements = AchievmentUtils.getUnactiveRecords(_achievements);
    showAchievements = activeAchievements + unsactiveAchievements;
    notifyListeners();
  }

  Future<void> checkAchievements() async {
    await _achievementChecker.checkAchievements();
  }
}
