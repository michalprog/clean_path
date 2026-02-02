import 'package:clean_path/data_types/daily_task.dart';
import 'package:clean_path/data_types/task_progress.dart';
import 'package:clean_path/l10n/app_localizations.dart';
import 'package:clean_path/utils_files/daily_task_utils.dart';
import 'package:clean_path/widgets/daily_task_widgets/daily_task_category_report_sheet.dart';
import 'package:flutter/material.dart';


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
    final rank = progress?.rank ?? 0;
    final totalCompleted = completedInCategory;
    final rankColor = DailyTaskUtils.levelColor(rank);
    final accentColor = Colors.green.shade800;

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
                      color: rankColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: IconTheme(
                      data: IconThemeData(
                        color: rankColor,
                        size: 22,
                      ),
                      child: icon,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: rankColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cs.surface, width: 1.5),
                    ),
                    child: Text(
                      '$rank',
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
                    border: Border.all(color: accentColor),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.dailyTaskSeeMore,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accentColor,
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



