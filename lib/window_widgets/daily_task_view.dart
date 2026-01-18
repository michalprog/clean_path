import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/utils_files/daily_task_utils.dart';
import '/enums/enums.dart';
import 'package:provider/provider.dart';
import '/providers/daily_tasks_provider.dart';
import '/widgets/daily_task_tile.dart';

class DailyTaskView extends StatelessWidget {
  const DailyTaskView({super.key});


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<DailyTasksProvider>(
      builder: (context, provider, _) {
        final tasks = provider.tasks;
        if (tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return DailyTaskTile(
              taskIcon: DailyTaskUtils.iconForType(task.type),
              taskTitle: DailyTaskUtils.titleForType(l10n, task.type, task.title),
              isCompleted: task.isCompletedToday,
              onCompleted: () => provider.markCompleted(task),
            );
          },
        );
      },
    );
  }
}
