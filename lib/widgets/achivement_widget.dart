import 'package:flutter/material.dart';
import '../data_types/achievement_record.dart';

class AchievementWidget extends StatelessWidget {
  final AchievementRecord record;
  const AchievementWidget({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          record.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        )
            : null, // Nie pokazuj tytułu, jeśli nieosiągnięte
        subtitle: record.isAchieved
            ? Text(
          record.description,
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
