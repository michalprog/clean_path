import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_types/task_progress.dart';
import '../enums/enums.dart';
import '../l10n/app_localizations.dart';
import '../providers/daily_tasks_provider.dart';
import '../utils_files/daily_task_utils.dart';
import '../widgets/daily_task_statistics_tile.dart';
import '../widgets/daily_tasks_status_widget.dart';
import '../widgets/statistic_list_tile.dart';

class DailyTaskStatisticsView extends StatelessWidget {
  const DailyTaskStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<Object>>(
      future: Future.wait([
        context.read<DailyTasksProvider>().fetchCompletionCounts(),
        context.read<DailyTasksProvider>().fetchTaskProgressMap(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        final counts = (data?[0] as Map<int, int>?) ?? {};
        final progressMap = (data?[1] as Map<int, TaskProgress>?) ?? {};
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
              return DailyTaskStatisticsTile(
                categoryLabel: categoryLabel,
                categoryType: typeIndex,
                completedInCategory: completedInCategory,
                progress: progressMap[typeIndex],
                tasks: tasks
                    .where((task) => task.type == typeIndex)
                    .toList(growable: false),
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
