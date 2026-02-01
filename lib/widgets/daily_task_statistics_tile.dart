import 'package:flutter/material.dart';
import '../data_types/daily_task.dart';
import '../data_types/task_progress.dart';
import '../l10n/app_localizations.dart';
import '../widgets/statistic_list_tile.dart';

class DailyTaskStatisticsTile extends StatelessWidget {
  final String categoryLabel;
  final int completedInCategory;
  final TaskProgress? progress;
  final List<DailyTask> tasks;

  const DailyTaskStatisticsTile({
    super.key,
    required this.categoryLabel,
    required this.completedInCategory,
    required this.progress,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return StatisticListTile(
      mainText: AppLocalizations.of(
        context,
      )!.dailyTaskCompletedForCategory(categoryLabel),
      highlightedText: '$completedInCategory',
    );
  }
}
