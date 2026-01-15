import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class DailyTaskTile extends StatelessWidget {
  const DailyTaskTile({
    super.key,
    required this.taskIcon,
    required this.taskTitle,
    required this.isCompleted,
    required this.onCompleted,
  });

  final Icon taskIcon;
  final String taskTitle;
  final bool isCompleted;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (isCompleted ? cs.primary : cs.secondary).withValues(
              alpha: 0.12,
            ),
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
            color:
                isCompleted
                    ? cs.onSurface.withValues(alpha: 0.60)
                    : cs.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            isCompleted ? l10n.dailyTaskCompleted : l10n.dailyTaskNotCompleted,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isCompleted ? cs.primary : cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged:
              isCompleted
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
