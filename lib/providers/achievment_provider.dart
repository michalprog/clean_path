import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '../achievement/achievement_checker.dart';
import '../data_types/achievement_record.dart';
import '../utils_files/achievment_utils.dart';
import '/enums/enums.dart';

class AchievementProvider extends ChangeNotifier {
  late final DatabaseProvider databaseProvider;
  List<AchievementRecord> _achievements = [];
  List<AchievementRecord> activeAchievements = [];
  List<AchievementRecord> unsactiveAchievements = [];
  List<AchievementRecord> showAchievements = [];
  AchievementProvider(this.databaseProvider);

  List<AchievementRecord> get achievements => _achievements;

  Future<void> fetchAchievements() async {
    _achievements = await databaseProvider.getAllAchievements();
    notifyListeners();
  }

  Future<void> activateAchievement(int id) async {
    await databaseProvider.activateAchievement(id);
    await fetchAchievements();
  }

  Future<void> statisticInicjalization() async {
    await checkAchievements();
    await fetchAchievements();
    activeAchievements = AchievmentUtils.getActiveRecords(_achievements);
    unsactiveAchievements = AchievmentUtils.getUnactiveRecords(_achievements);
    showAchievements=activeAchievements+unsactiveAchievements;
    notifyListeners();
  }
  Future<void> checkAchievements() async {
    final checker = AchievementChecker(databaseProvider);
    await checker.checkAchievements();
  }
}
