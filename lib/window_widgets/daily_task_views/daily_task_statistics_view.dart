import 'package:clean_path/data_types/daily_task.dart';
import 'package:clean_path/data_types/task_progress.dart';
import 'package:clean_path/enums/enums.dart';
import 'package:clean_path/l10n/app_localizations.dart';
import 'package:clean_path/providers/daily_tasks_provider.dart';
import 'package:clean_path/utils_files/daily_task_utils.dart';
import 'package:clean_path/widgets/Statistic_list_tile.dart';
import 'package:clean_path/widgets/daily_task_widgets/daily_tasks_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
              return DailyTaskCategoryStatisticsCard(
                categoryLabel: categoryLabel,
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

class DailyTaskCategoryStatisticsCard extends StatelessWidget {
  final String categoryLabel;
  final int completedInCategory;
  final TaskProgress? progress;
  final List<DailyTask> tasks;

  const DailyTaskCategoryStatisticsCard({
    super.key,
    required this.categoryLabel,
    required this.completedInCategory,
    required this.progress,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return StatisticListTile(
      mainText: AppLocalizations.of(context)!
          .dailyTaskCompletedForCategory(categoryLabel),
      highlightedText: '$completedInCategory',
    );
  }
}