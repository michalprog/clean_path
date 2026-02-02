import 'package:clean_path/data_types/daily_task.dart';
import 'package:clean_path/data_types/task_progress.dart';
import 'package:clean_path/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'report_stat_card.dart';

class DailyTaskCategoryReportSheet extends StatelessWidget {
  const DailyTaskCategoryReportSheet({
    super.key,
    required this.title,
    required this.icon,
    required this.completedInCategory,
    required this.progress,
    required this.tasks,
  });

  final String title;
  final Icon icon;
  final int completedInCategory;
  final TaskProgress? progress;
  final List<DailyTask> tasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final streak = progress?.streak ?? 0;
    final rank = progress?.rank ?? 0;
    final tasksToNext = progress?.tasksToNextLevel ?? 0;
    final totalCompleted = completedInCategory;
    final accentColor = Colors.green.shade800;
    final accentBackground = accentColor.withValues(alpha: 0.12);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: IconTheme(
                      data: IconThemeData(
                        color: accentColor,
                        size: 22,
                      ),
                      child: icon,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                ReportStatCard(
                  icon: Icons.fact_check_rounded,
                  label: l10n.dailyTaskProgressTotalCompletedLabel,
                  value: '$totalCompleted',
                ),
                ReportStatCard(
                  icon: Icons.emoji_events_rounded,
                  label: l10n.dailyTaskProgressRankLabel,
                  value: '$rank',
                ),
                ReportStatCard(
                  icon: Icons.local_fire_department_rounded,
                  label: l10n.dailyTaskProgressStreakLabel,
                  value: '$streak',
                ),
                ReportStatCard(
                  icon: Icons.trending_up_rounded,
                  label: l10n.dailyTaskProgressTasksToNextLevelLabel,
                  value: '$tasksToNext',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.dailyTaskStatusTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...tasks.map(
                  (task) => Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: ListTile(
                      leading: Icon(
                        task.isCompletedToday
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: task.isCompletedToday ? accentColor : cs.outline,
                      ),
                      title: Text(task.title),
                      subtitle: Text(
                        task.isCompletedToday
                            ? l10n.dailyTaskCompleted
                            : l10n.dailyTaskNotCompleted,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: task.isCompletedToday
                              ? accentColor
                              : cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}