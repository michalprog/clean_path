import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/enums.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("zadanie codzienne")),
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
                taskTitle: task.title,
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