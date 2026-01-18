import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/enums.dart';
import '../l10n/app_localizations.dart';
import '../providers/daily_tasks_provider.dart';
import '../utils_files/daily_task_utils.dart';
import '../widgets/daily_tasks_status_widget.dart';
import '../widgets/statistic_list_tile.dart';

class DailyTaskStatisticsView extends StatelessWidget {
  const DailyTaskStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<Map<int, int>>(
      future: context.read<DailyTasksProvider>().fetchCompletionCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final counts = snapshot.data ?? {};
        final totalCompleted = counts.values.fold<int>(
          0,
              (sum, value) => sum + value,
        );
        final tasks = context.watch<DailyTasksProvider>().tasks;
        return ListView(
          children: [
            StatisticListTile(
              mainText: l10n.dailyTaskTotalCompleted,
              highlightedText: '$totalCompleted',
              typ: 1,
            ),
            ...DailyTaskType.values.map((type) {
              final typeIndex = type.index + 1;
              final completedInCategory = counts[typeIndex] ?? 0;
              final categoryLabel = DailyTaskUtils.titleForType(
                l10n,
                typeIndex,
                '',
              );
              return StatisticListTile(
                mainText:
                l10n.dailyTaskCompletedForCategory(categoryLabel),
                highlightedText: '$completedInCategory',
              );
            }),
            DailyTasksStatusWidget(
              tasks: context.watch<DailyTasksProvider>().tasks,
            ),
            const SizedBox(height: 50),
          ],
        );
      },
    );
  }
}
//TODO stan dzisiejszych tasków