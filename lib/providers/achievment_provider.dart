import 'package:flutter/material.dart';
import 'package:clean_path/providers/database_provider.dart';
import '/achievement/achievement_checker.dart';
import '/data_types/achievement_record.dart';
import '/utils_files/achievment_utils.dart';

class AchievementProvider extends ChangeNotifier {
  late DatabaseProvider _databaseProvider;

  List<AchievementRecord> _achievements = [];
  List<AchievementRecord> activeAchievements = [];
  List<AchievementRecord> unsactiveAchievements = [];
  List<AchievementRecord> showAchievements = [];

  void update(DatabaseProvider dbProvider) {
    _databaseProvider = dbProvider;
  }

  List<AchievementRecord> get achievements => _achievements;

  Future<void> fetchAchievements() async {
    _achievements = await _databaseProvider.getAllAchievements();
    notifyListeners();
  }

  Future<void> activateAchievement(int id) async {
    await _databaseProvider.activateAchievement(id);
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
    final checker = AchievementChecker(_databaseProvider);
    await checker.checkAchievements();
  }
}
