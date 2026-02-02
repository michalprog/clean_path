import 'package:clean_path/utils_files/daily_task_utils.dart';
import 'package:flutter/material.dart';

import '/data_types/task_progress.dart';
import '/utils_files/task_progress_utils.dart';
import 'rank_indicator.dart';
import 'streak_inline.dart';

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

    final totalTasksCompleted = progress?.totalTasksCompleted ?? 0;
    final rank = progress?.rank ?? 0;
    final streak = progress?.streak ?? 0;
    final tasksToNext = progress?.tasksToNextLevel ?? 0;
    final rankColor = DailyTaskUtils.levelColor(rank);
    final accentColor = Colors.green.shade800;
    final accentBackground = accentColor.withValues(alpha: 0.12);

    final levelStep = rank < earlyLevelMax ? earlyLevelStep : lateLevelStep;
    final currentLevelProgress = (levelStep - tasksToNext).clamp(0, levelStep);

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 1.5,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            leading: Stack(
              alignment: Alignment.center,
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
                    child: taskIcon,
                  ),
                ),
                if (progress != null)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: rankColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: cs.surface, width: 1.5),
                      ),
                      child: Text(
                        '$rank',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
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
                  RankIndicator(rank: totalTasksCompleted),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: levelStep == 0 ? 0 : currentLevelProgress / levelStep,
                            minHeight: 6,
                            backgroundColor: cs.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(rankColor),
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
                  StreakInline(value: streak),
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
        ),

        // 🔹 Pasek boczny poziomu (kolor z levelColor)
        if (progress != null)
          Positioned(
            left: 16, // = horizontal margin Card
            top: 8, // = vertical margin Card
            bottom: 8,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                color: DailyTaskUtils.levelColor(rank),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }
}
