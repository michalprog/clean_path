import 'package:flutter/material.dart';
import '/data_types/daily_task.dart';
import '/utils_files/daily_task_utils.dart';
import '/l10n/app_localizations.dart';

class DailyTasksStatusWidget extends StatelessWidget {
  const DailyTasksStatusWidget({
    super.key,
    required this.tasks,
  });

  final List<DailyTask> tasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: Text(
                  'Aktualny stan zadań codziennych',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),


            // ======= RESZTA BEZ ZMIAN =======
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: tasks.map(
                        (task) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: (task.isCompletedToday
                                  ? cs.primary
                                  : cs.secondary)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: IconTheme(
                              data: IconThemeData(
                                color: task.isCompletedToday
                                    ? cs.primary
                                    : cs.secondary,
                                size: 22,
                              ),
                              child:
                              DailyTaskUtils.iconForType(task.type),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            DailyTaskUtils.titleForType(
                              l10n,
                              task.type,
                              task.title,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                ),
                TableRow(
                  children: tasks.map(
                        (task) => Center(
                      child: Checkbox(
                        value: task.isCompletedToday,
                        onChanged: null,
                      ),
                    ),
                  ).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}