import 'package:clean_path/data_types/daily_task.dart';
import 'package:clean_path/utils_files/daily_task_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('iconForType returns expected icon for each task type', () {
    expect(DailyTaskUtils.iconForType(1).icon, Icons.water_drop);
    expect(DailyTaskUtils.iconForType(2).icon, Icons.fitness_center);
    expect(DailyTaskUtils.iconForType(3).icon, Icons.self_improvement);
    expect(DailyTaskUtils.iconForType(4).icon, Icons.menu_book);
  });

  test('markerForTaskType returns task-specific emoji', () {
    expect(DailyTaskUtils.markerForTaskType(0), '💧');
    expect(DailyTaskUtils.markerForTaskType(1), '💪');
    expect(DailyTaskUtils.markerForTaskType(2), '🧘');
    expect(DailyTaskUtils.markerForTaskType(3), '📚');
    expect(DailyTaskUtils.markerForTaskType(99), '✅');
  });

  test('markerForMenu returns fixed menu marker', () {
    expect(DailyTaskUtils.markerForMenu(), '📋');
  });

  test('totalTasksCount and completedTodayCount calculate values correctly', () {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final tasks = <DailyTask>[
      DailyTask(type: 1, title: 'Hydration', lastCompleted: now),
      DailyTask(type: 2, title: 'Workout', lastCompleted: yesterday),
      const DailyTask(type: 3, title: 'Meditation'),
    ];

    expect(DailyTaskUtils.totalTasksCount(tasks), 3);
    expect(DailyTaskUtils.completedTodayCount(tasks), 1);
  });

  test('levelColor returns color based on level ranges', () {
    expect(DailyTaskUtils.levelColor(0), Colors.grey.shade500);
    expect(DailyTaskUtils.levelColor(3), Colors.green.shade600);
    expect(DailyTaskUtils.levelColor(6), Colors.blue.shade600);
    expect(DailyTaskUtils.levelColor(9), Colors.purple.shade600);
    expect(DailyTaskUtils.levelColor(10), Colors.amber.shade700);
  });
}