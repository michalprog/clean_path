import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/data_types/achievement_record.dart';

class AchievementWidget extends StatelessWidget {
  final AchievementRecord record;
  const AchievementWidget({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String localizedTitle() {
      switch (record.id) {
        case 1:
          return l10n.achievement1Title;
        case 2:
          return l10n.achievement2Title;
        case 3:
          return l10n.achievement3Title;
        case 4:
          return l10n.achievement4Title;
        case 5:
          return l10n.achievement5Title;
        case 6:
          return l10n.achievement6Title;
        case 7:
          return l10n.achievement7Title;
        case 8:
          return l10n.achievement8Title;
        case 9:
          return l10n.achievement9Title;
        case 10:
          return l10n.achievement10Title;
        default:
          return record.title;
      }
    }

    String localizedDescription() {
      switch (record.id) {
        case 1:
          return l10n.achievement1Description;
        case 2:
          return l10n.achievement2Description;
        case 3:
          return l10n.achievement3Description;
        case 4:
          return l10n.achievement4Description;
        case 5:
          return l10n.achievement5Description;
        case 6:
          return l10n.achievement6Description;
        case 7:
          return l10n.achievement7Description;
        case 8:
          return l10n.achievement8Description;
        case 9:
          return l10n.achievement9Description;
        case 10:
          return l10n.achievement10Description;
        default:
          return record.description;
      }
    }

    return Card(
      elevation: 3,
      color: record.isAchieved ? Colors.amber.shade100 : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          record.isAchieved ? Icons.emoji_events : Icons.help_outline,
          color: record.isAchieved ? Colors.amber.shade800 : Colors.grey,
          size: 40,
        ),
        title: record.isAchieved
            ? Text(
          localizedTitle(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        )
            : null, // Nie pokazuj tytułu, jeśli nieosiągnięte
        subtitle: record.isAchieved
            ? Text(
          localizedDescription(),
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
        )
            : null, // Nie pokazuj opisu, jeśli nieosiągnięte
        trailing: record.isAchieved
            ? Text(
          "🎉",
          style: TextStyle(fontSize: 30),
        )
            : null,
      ),
    );
  }
}