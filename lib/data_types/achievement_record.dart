import 'package:clean_path/enums/enums.dart';
import 'package:flutter/material.dart';

class AchievementRecord {
  final int id;
  final bool isAchieved;
  final String title;
  final String description;
  final DateTime? achievementDate;
  final IconData icon;
  final RarityLevel rarity;

  AchievementRecord({
    required this.id,
    required this.isAchieved,
    required this.title,
    required this.description,
    required this.icon,
    required this.rarity,
    this.achievementDate,
  });

  factory AchievementRecord.fromMap(Map<String, dynamic> map) {
    return AchievementRecord(
      id: map['id'] as int,
      isAchieved: map['is_achieved'] == 1,
      title: map['title'] as String,
      description: map['description'] as String,
      icon: IconData(
        (map['icon_codepoint'] as int?) ?? Icons.emoji_events.codePoint,
        fontFamily: map['icon_font_family'] as String? ?? 'MaterialIcons',
        fontPackage: map['icon_font_package'] as String?,
      ),
      rarity: _rarityFromString(map['rarity'] as String?),
      achievementDate: map['achievement_date'] != null
          ? DateTime.parse(map['achievement_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_achieved': isAchieved ? 1 : 0,
      'title': title,
      'description': description,
      'icon_codepoint': icon.codePoint,
      'icon_font_family': icon.fontFamily,
      'icon_font_package': icon.fontPackage,
      'rarity': rarity.name,
      'achievement_date': achievementDate?.toIso8601String(),
    };
  }

  static RarityLevel _rarityFromString(String? rarityName) {
    return RarityLevel.values.firstWhere(
          (rarity) => rarity.name == rarityName,
      orElse: () => RarityLevel.common,
    );
  }
}