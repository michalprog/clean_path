import 'package:clean_path/providers/database_provider.dart';
import 'package:flutter/material.dart';
import '../data_types/achievement_record.dart';
import '../utils_files/achievment_utils.dart';
import '/enums/enums.dart';

class AchievementProvider extends ChangeNotifier {
  late final DatabaseProvider databaseProvider;
  List<AchievementRecord> allAchievements = [];
  bool isLoading = false;

  AchievementProvider(this.databaseProvider);

  List<AchievementRecord> get achievements => allAchievements;

  Future<void> fetchAchievements() async {
    isLoading = true;
    notifyListeners();

    allAchievements = await databaseProvider.getAllAchievements();

    isLoading = false;
    notifyListeners();
  }
}

