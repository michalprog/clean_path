import 'package:clean_path/data_types/achievement_record.dart';
import 'package:clean_path/enums/enums.dart';
import 'package:clean_path/utils_files/achievment_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final testAchievements = <AchievementRecord>[
  AchievementRecord(
    id: 1,
    isAchieved: true,
    title: 'First Step',
    description: 'Complete your first task',
    icon: Icons.flag,
    rarity: RarityLevel.common,
    achievementDate: DateTime(2026, 2, 20),
  ),
  AchievementRecord(
    id: 2,
    isAchieved: true,
    title: '3 Day Streak',
    description: 'Complete tasks 3 days in a row',
    icon: Icons.local_fire_department,
    rarity: RarityLevel.rare,
    achievementDate: DateTime(2026, 2, 22),
  ),
  AchievementRecord(
    id: 3,
    isAchieved: false,
    title: '7 Day Streak',
    description: 'Complete tasks 7 days in a row',
    icon: Icons.whatshot,
    rarity: RarityLevel.epic,
  ),
  AchievementRecord(
    id: 4,
    isAchieved: false,
    title: 'Marathon',
    description: 'Complete 100 tasks',
    icon: Icons.directions_run,
    rarity: RarityLevel.legendary,
  ),
  AchievementRecord(
    id: 5,
    isAchieved: true,
    title: 'Task Master',
    description: 'Complete 50 tasks',
    icon: Icons.emoji_events,
    rarity: RarityLevel.rare,
    achievementDate: DateTime(2026, 2, 25),
  ),
];
    void main()
{
  test('function test getActiveRecords', () {
    final result = AchievmentUtils.getActiveRecords(testAchievements);

    expect(result.length, 3);
    expect(result.every((r) => r.isAchieved), true);
  });
  test('function test getUnactiveRecords', () {
    final result = AchievmentUtils.getUnactiveRecords(testAchievements);

    expect(result.length, 2);
    expect(result.every((r) => !r.isAchieved), true);
  });

  group('function tests totalCompletedTasks', () {
    test('returns 0 for empty map', () {
      final result = AchievmentUtils.totalCompletedTasks({});
      expect(result, 0);
    });

    test('sums values correctly', () {
      final map = {1: 2, 2: 5, 3: 1};
      final result = AchievmentUtils.totalCompletedTasks(map);
      expect(result, 8);
    });

    test('handles zeros', () {
      final map = {1: 0, 2: 0, 3: 4};
      final result = AchievmentUtils.totalCompletedTasks(map);
      expect(result, 4);
    });
  });
}

/*

 */