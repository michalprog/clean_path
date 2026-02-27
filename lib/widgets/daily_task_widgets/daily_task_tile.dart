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

    final accentColor = rankColor;
    final accentBackground = Color.alphaBlend(
      accentColor.withValues(alpha: 0.14),
      cs.surfaceContainerHighest,
    );

    final levelStep = tasksRequiredForNextLevel(rank);
    final currentLevelProgress = (levelStep - tasksToNext).clamp(0, levelStep);


    final cardColor = cs.surfaceContainerHighest;
    final outlineColor = cs.outlineVariant.withValues(alpha: 0.22);


    final titleColor = isCompleted
        ? cs.onSurface.withValues(alpha: 0.55)
        : cs.onSurface;

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),


          elevation: 0.6,
          shadowColor: Colors.black.withValues(alpha: 0.06),


          color: cardColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: outlineColor),
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
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.18),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: IconTheme(
                    data: IconThemeData(

                      color: isCompleted
                          ? cs.onSurfaceVariant.withValues(alpha: 0.85)
                          : accentColor,
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(

                        color: isCompleted
                            ? rankColor.withValues(alpha: 0.70)
                            : rankColor,

                        borderRadius: BorderRadius.circular(8),


                        border: Border.all(
                          color: cs.surface,
                          width: 1.25,
                        ),


                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '$rank',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.1,
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
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
                color: titleColor,
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
                            value: levelStep == 0
                                ? 0
                                : (currentLevelProgress / levelStep).clamp(0.0, 1.0),
                            minHeight: 6,

                            // tło progressa bardziej miękkie i spójne z kartą
                            backgroundColor: cs.surfaceContainerHigh,

                            // rankColor, ale przygaszony gdy completed
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCompleted
                                  ? rankColor.withValues(alpha: 0.55)
                                  : rankColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currentLevelProgress.toInt()} / $levelStep',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w700,
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

            trailing: Checkbox(
              value: isCompleted,


              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return cs.onSurface.withValues(alpha: 0.12);
                }
                if (states.contains(WidgetState.selected)) {
                  return cs.primary;
                }
                return null; // default
              }),

              onChanged: isCompleted
                  ? null
                  : (value) {
                if (value == true) onCompleted();
              },
            ),
            onTap: isCompleted ? null : onCompleted,
          ),
        ),

        if (progress != null)
          Positioned(
            left: 16,
            top: 8,
            bottom: 8,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                // pasek poziomu z lekkim “depth”
                color: isCompleted
                    ? rankColor.withValues(alpha: 0.55)
                    : rankColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}