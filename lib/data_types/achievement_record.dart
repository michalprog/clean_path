class AchievementRecord {
  final int id;
  final bool isAchieved;
  final String title;
  final String description;
  final DateTime? achievementDate;
  // #Todo dodać ikonę oraz rzadkość
  AchievementRecord({
    required this.id,
    required this.isAchieved,
    required this.title,
    required this.description,
    this.achievementDate,
  });


  factory AchievementRecord.fromMap(Map<String, dynamic> map) {
    return AchievementRecord(
      id: map['id'] as int,
      isAchieved: map['is_achieved'] == 1,
      title: map['title'] as String,
      description: map['description'] as String,
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
      'achievement_date': achievementDate?.toIso8601String(),
    };
  }
}

