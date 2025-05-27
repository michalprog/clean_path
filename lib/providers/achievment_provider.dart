import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '../data_types/achievement_record.dart';
import '/enums/enums.dart';

class AchievementProvider extends ChangeNotifier {
  late final DatabaseProvider databaseProvider;
  List<AchievementRecord> _achievements = [];
  AchievementProvider(this.databaseProvider);


  List<AchievementRecord> get achievements => _achievements;

  Future<void> fetchAchievements() async {
    _achievements = await databaseProvider.getAllAchievements();
    notifyListeners(); // Aktualizacja widoków
  }

  Future<void> activateAchievement(int id) async {
    await databaseProvider.activateAchievement(id);
    await fetchAchievements();
  }




}
