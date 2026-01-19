import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/enums/enums.dart';
class DailyTaskUtils {
 static Icon iconForType(int type) {
    final dailyType = DailyTaskType.values[type - 1];
    switch (dailyType) {
      case DailyTaskType.hydration:
        return const Icon(Icons.water_drop);
      case DailyTaskType.workout:
        return const Icon(Icons.fitness_center);
      case DailyTaskType.meditation:
        return const Icon(Icons.self_improvement);
      case DailyTaskType.learning:
        return const Icon(Icons.menu_book);
    }
  }

  static String titleForType(AppLocalizations l10n, int type, String fallback) {
    final dailyType = DailyTaskType.values[type - 1];
    switch (dailyType) {
      case DailyTaskType.hydration:
        return l10n.dailyTaskHydration;
      case DailyTaskType.workout:
        return l10n.dailyTaskWorkout;
      case DailyTaskType.meditation:
        return l10n.dailyTaskMeditation;
      case DailyTaskType.learning:
        return l10n.dailyTaskLearning;
    }
  }
 static String markerForTaskType(int taskType) {
   switch (taskType) {
     case 0: // woda
       return '💧';
     case 1: // trening / muskuły
       return '💪';
     case 2: // medytacja
       return '🧘';
     case 3: // książka
       return '📚';
     default:
       return '✅';
   }
 }

}
