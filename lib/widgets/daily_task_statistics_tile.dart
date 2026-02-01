import 'package:flutter/material.dart';

import '../data_types/daily_task.dart';
import '../data_types/task_progress.dart';
import '../l10n/app_localizations.dart';
import '../utils_files/daily_task_utils.dart';

class DailyTaskStatisticsTile extends StatelessWidget {
  const DailyTaskStatisticsTile({
    super.key,
    required this.categoryLabel,
    required this.categoryType,
    required this.completedInCategory,
    required this.progress,
    required this.tasks,
  });

  final String categoryLabel;
  final int categoryType;
  final int completedInCategory;
  final TaskProgress? progress;
  final List<DailyTask> tasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final icon = DailyTaskUtils.iconForType(categoryType);
    final level = progress?.level ?? 0;
    final totalCompleted = completedInCategory;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showReport(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: IconTheme(
                      data: IconThemeData(
                        color: cs.primary,
                        size: 22,
                      ),
                      child: icon,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cs.surface, width: 1.5),
                    ),
                    child: Text(
                      '$level',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.dailyTaskProgressTotalCompletedLabel}: $totalCompleted',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: cs.primary),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.dailyTaskSeeMore,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReport(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DailyTaskCategoryReportSheet(
          title: l10n.dailyTaskCategoryReportTitle(categoryLabel),
          icon: DailyTaskUtils.iconForType(categoryType),
          progress: progress,
          tasks: tasks,
          completedInCategory: completedInCategory,
        );
      },
    );
  }
}

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
                      color: cs.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: IconTheme(
                      data: IconThemeData(
                        color: cs.primary,
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
                _ReportStatCard(
                  icon: Icons.fact_check_rounded,
                  label: l10n.dailyTaskProgressTotalCompletedLabel,
                  value: '$totalCompleted',
                ),
                _ReportStatCard(
                  icon: Icons.emoji_events_rounded,
                  label: l10n.dailyTaskProgressRankLabel,
                  value: '$rank',
                ),
                _ReportStatCard(
                  icon: Icons.local_fire_department_rounded,
                  label: l10n.dailyTaskProgressStreakLabel,
                  value: '$streak',
                ),
                _ReportStatCard(
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
                        color: task.isCompletedToday ? cs.primary : cs.outline,
                      ),
                      title: Text(task.title),
                      subtitle: Text(
                        task.isCompletedToday
                            ? l10n.dailyTaskCompleted
                            : l10n.dailyTaskNotCompleted,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: task.isCompletedToday ? cs.primary : cs.onSurfaceVariant,
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

class _ReportStatCard extends StatelessWidget {
  const _ReportStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}