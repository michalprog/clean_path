import 'package:flutter/material.dart';

import '/data_types/task_progress.dart';
import '/l10n/app_localizations.dart';

class DailyTaskTile extends StatelessWidget {
  const DailyTaskTile({
    super.key,
    required this.taskIcon,
    required this.taskTitle,
    required this.isCompleted,
    required this.onCompleted,
    this.progress,
  });

  final Icon taskIcon;
  final String taskTitle;
  final bool isCompleted;
  final VoidCallback onCompleted;
  final TaskProgress? progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final totalCompleted = progress?.totalTasksCompleted ?? 0;
    final rank = progress?.rank ?? 0;
    final streak = progress?.streak ?? 0;
    final tasksToNext = progress?.tasksToNextLevel ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (isCompleted ? cs.primary : cs.secondary).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: IconTheme(
            data: IconThemeData(
              color: isCompleted ? cs.primary : cs.secondary,
              size: 22,
            ),
            child: taskIcon,
          ),
        ),

        title: Text(
          taskTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isCompleted ? cs.onSurface.withValues(alpha: 0.60) : cs.onSurface,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // status + streak badge w jednej linii (to jest bezpieczne wysokościowo)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isCompleted ? l10n.dailyTaskCompleted : l10n.dailyTaskNotCompleted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isCompleted ? cs.primary : cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (progress != null) ...[
                    const SizedBox(width: 8),
                    _StreakBadge(value: streak),
                  ],
                ],
              ),

              const SizedBox(height: 10),

              // 3 staty jako ikony (bez ramek)
              if (progress != null)
                Row(
                  children: [
                    _IconStat(
                      icon: Icons.emoji_events_rounded,
                      value: '$rank',
                      label: l10n.dailyTaskProgressRankLabel,
                    ),
                    const SizedBox(width: 12),
                    _IconStat(
                      icon: Icons.check_circle_rounded,
                      value: '$totalCompleted',
                      label: l10n.dailyTaskProgressTotalCompletedLabel,
                    ),
                    const SizedBox(width: 12),
                    _IconStat(
                      icon: Icons.trending_up_rounded,
                      value: '$tasksToNext',
                      label: l10n.dailyTaskProgressTasksToNextLevelLabel,
                    ),
                  ],
                ),
            ],
          ),
        ),

        // trailing tylko checkbox = brak overflow
        trailing: Checkbox(
          value: isCompleted,
          onChanged: isCompleted
              ? null
              : (value) {
            if (value == true) onCompleted();
          },
        ),

        onTap: isCompleted ? null : onCompleted,
      ),
    );
  }
}

class _IconStat extends StatelessWidget {
  const _IconStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_rounded, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            '$value',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}
