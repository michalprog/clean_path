import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class DailyTasksStatusWidget extends StatelessWidget {
   const DailyTasksStatusWidget({super.key, required this.isCompleted});
  final List<bool> isCompleted;
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
    child: Table(

    )
    );
  }
}
