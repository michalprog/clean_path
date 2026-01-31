import 'package:flutter/material.dart';

import '/data_types/task_progress.dart';
import '/l10n/app_localizations.dart';
import '/utils_files/task_progress_utils.dart';

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
    final level = progress?.level ?? 0;
    final streak = progress?.streak ?? 0;
    final tasksToNext = progress?.tasksToNextLevel ?? 0;
    final levelStep = level < earlyLevelMax ? earlyLevelStep : lateLevelStep;
    final currentLevelProgress = (levelStep - tasksToNext).clamp(0, levelStep);

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

        subtitle: progress == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _RankIndicator(rank: rank),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalCompleted',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    l10n.dailyTaskProgressTotalCompletedLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: levelStep == 0 ? 0 : currentLevelProgress / levelStep,
                        minHeight: 6,
                        backgroundColor: cs.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${currentLevelProgress.toInt()} / $levelStep',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _StreakInline(value: streak),
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

class _RankIndicator extends StatelessWidget {
  const _RankIndicator({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.emoji_events_rounded, size: 18, color: cs.primary),
        const SizedBox(height: 4),
        Text(
          '$rank',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _StreakInline extends StatelessWidget {
  const _StreakInline({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '+$value',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.primary,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.local_fire_department_rounded, size: 16, color: cs.primary),
      ],
    );
  }
}