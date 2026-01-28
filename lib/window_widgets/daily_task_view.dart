import 'package:flutter/material.dart';
import '../data_types/task_progress.dart';
import '../providers/account_provider.dart';
import '/enums/enums.dart';
import '/l10n/app_localizations.dart';
import '/utils_files/daily_task_utils.dart';
import 'package:provider/provider.dart';
import '/providers/daily_tasks_provider.dart';
import '/widgets/daily_task_tile.dart';

class DailyTaskView extends StatefulWidget {
  const DailyTaskView({super.key});

  @override
  State<DailyTaskView> createState() => _DailyTaskViewState();
}

class _DailyTaskViewState extends State<DailyTaskView> {
  late Future<Map<int, TaskProgress>> _progressFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _progressFuture =
        context.read<DailyTasksProvider>().fetchTaskProgressMap();
  }

  void _refreshProgress() {
    setState(() {
      _progressFuture =
          context.read<DailyTasksProvider>().fetchTaskProgressMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<DailyTasksProvider>(
      builder: (context, provider, _) {
        final tasks = provider.tasks;
        if (tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return FutureBuilder<Map<int, TaskProgress>>(
          future: _progressFuture,
          builder: (context, snapshot) {
            final progressMap = snapshot.data ?? {};
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return DailyTaskTile(
                  taskIcon: DailyTaskUtils.iconForType(task.type),
                  taskTitle: DailyTaskUtils.titleForType(
                    l10n,
                    task.type,
                    task.title,
                  ),
                  isCompleted: task.isCompletedToday,
                  progress: progressMap[task.type],
                  onCompleted: () async {
                    await provider.markCompleted(task);
                    if (context.mounted) {
                      await context
                          .read<AccountProvider>()
                          .applyLevelingAction(
                        LevelingAction.dailyTaskCompleted,
                      );
                      _refreshProgress();
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
