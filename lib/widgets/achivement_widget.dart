import 'package:flutter/material.dart';
import '../data_types/achievement_record.dart';

class AchievementWidget extends StatelessWidget {
  final AchievementRecord record;
  const AchievementWidget({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          record.isAchieved ? Icons.emoji_events : Icons.help_outline, // Znak zapytania dla nieaktywnych
          color: record.isAchieved ? Colors.amber : Colors.grey, // Kolor dla aktywnych/niedostępnych
          size: 40,
        ),
        title: Text(
          record.isAchieved ? record.title : "Nieznane osiągnięcie", // Ukrycie nazwy, jeśli nie zdobyte
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: record.isAchieved ? Colors.white : Colors.grey,
          ),
        ),
        subtitle: Text(
          record.isAchieved ? record.description : "Zdobyj to osiągnięcie, aby odkryć jego szczegóły!",
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: record.isAchieved ? Colors.white70 : Colors.grey,
          ),
        ),
        trailing: record.isAchieved
            ? Text(
          "🎉",
          style: TextStyle(fontSize: 30),
        )
            : null, // Nie pokazuj nic dla nieaktywnych
      ),
    );
  }
}
