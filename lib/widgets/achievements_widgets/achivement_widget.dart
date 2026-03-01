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
    final Color accentColor = rarityColor(record.rarity);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap:
      unlocked
          ? () {
        showDialog<void>(
          context: context,
          builder:
              (_) => AlertDialog(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            content: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: accentColor.withOpacity(0.55),
                  width: 1.4,
                ),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Color.alphaBlend(
                      accentColor.withOpacity(0.24),
                      Theme.of(context).colorScheme.surface,
                    ),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.34),
                          accentColor.withOpacity(0.16),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: accentColor.withOpacity(0.65),
                      ),
                    ),
                    child: Icon(
                      record.icon,
                      color: accentColor,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    record.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    record.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
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
