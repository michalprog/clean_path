import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/enums.dart';
import '../l10n/app_localizations.dart';
import '../providers/daily_tasks_provider.dart';
import '../widgets/daily_task_tile.dart';

class DailyTaskView extends StatelessWidget {
  const DailyTaskView({super.key});

  Icon _iconForType(int type) {
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

  String _titleForType(AppLocalizations l10n, int type, String fallback) {
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
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text(l10n.dailyTaskTitle),
      ),
      body: Consumer<DailyTasksProvider>(
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
                taskIcon: _iconForType(task.type),
                taskTitle: _titleForType(l10n, task.type, task.title),
                isCompleted: task.isCompletedToday,
                onCompleted: () => provider.markCompleted(task),
              );
            },
          );
        },
      ),
    );
  }
}