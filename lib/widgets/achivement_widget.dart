import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/data_types/achievement_record.dart';

class AchievementWidget extends StatelessWidget {
  final AchievementRecord record;

  const AchievementWidget({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool unlocked = record.isAchieved;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: unlocked
          ? () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(record.title),
            content: Text(record.description),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
          : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: unlocked
              ? Colors.white.withOpacity(0.85)
              : Colors.white.withOpacity(0.30),
          border: Border.all(
            color: unlocked
                ? Colors.amber.withOpacity(0.45)
                : Colors.white.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(unlocked ? 0.12 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            unlocked ? Icons.emoji_events : Icons.lock_outline,
            size: 36,
            color: unlocked
                ? Colors.amber.shade800
                : Colors.black.withOpacity(0.35),
          ),
        ),
      ),
    );
  }
}

