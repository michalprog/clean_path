import 'package:clean_path/enums/enums.dart';
import 'package:flutter/material.dart';
import '/data_types/achievement_record.dart';

class AchievementWidget extends StatelessWidget {
  final AchievementRecord record;

  const AchievementWidget({super.key, required this.record});

  Color rarityColor(RarityLevel rarity) {
    switch (rarity) {
      case RarityLevel.common:
        return Colors.grey;
      case RarityLevel.uncommon:
        return Colors.green;
      case RarityLevel.rare:
        return Colors.blue.shade700;
      case RarityLevel.epic:
        return Colors.deepPurple.shade400;
      case RarityLevel.legendary:
        return Colors.yellow;
      case RarityLevel.mythic:
        return Colors.purpleAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool unlocked = record.isAchieved;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap:
          unlocked
              ? () {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: Text(record.title),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(record.description),
                            const SizedBox(height: 8),
                            Text('Rarity: ${record.rarity.name}'),
                          ],
                        ),
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
          color:
              unlocked
                  ? Colors.white.withOpacity(0.85)
                  : Colors.white.withOpacity(0.30),
          border: Border.all(
            color:
                unlocked
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
            unlocked ? record.icon : Icons.lock_outline,
            size: 36,
            color:
                unlocked
                    ? rarityColor(record.rarity)
                    : Colors.black.withOpacity(0.35),
          ),
        ),
      ),
    );
  }
}
